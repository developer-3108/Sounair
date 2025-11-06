//
//  MusicPlayerViewModel.swift
//  Sounair
//
//  Created by Akshat Srivastava on 06/11/25.
//

import Foundation
import CoreML
import Vision
import MediaPlayer
import AVFoundation
import UIKit
import SwiftUI
internal import Combine

class MusicPlayerViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var currentGesture: String = ""
    @Published var sampleBuffer: CMSampleBuffer?
    @Published var lastPlayedTrack: Int = -1
    
    let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    private var gestureModel: MyHandPoseModel5!
    private var isInferencing: Bool = false
    
    private var players: [AVPlayer] = []
    private var currentPlayer: AVPlayer?
    private var timeObserver: Any?
    private weak var timeObserverOwner: AVPlayer?
    
    private var currentGestureCounter = 0
    private var lastSeenGesture: String = ""
    private let requiredConfidenceCount = 20
    
    private var isRemoteHandlersRegistered = false
    
    var songsName: [String] = ["Espresso", "Closer", "Attention", "We Don't Talk Anymore", "Like I Do", "I Like Me Better", "Infinity", "Can We Kiss Forever?", "Royalty"]
    
    @Published var songName: String = ""
    @Published var artistName: String = ""
    @Published var imageName: String = ""
    @Published var currentSong: String = ""
    @Published var isSongPlaying: Bool = false
    
    private let gridZones: [CGRect] = [
        CGRect(x: 0.0, y: 0.17, width: 0.33, height: 0.17),
        CGRect(x: 0.33, y: 0.17, width: 0.33, height: 0.17),
        CGRect(x: 0.66, y: 0.17, width: 0.33, height: 0.17),
        CGRect(x: 0.0, y: 0.34, width: 0.33, height: 0.17),
        CGRect(x: 0.33, y: 0.34, width: 0.33, height: 0.17),
        CGRect(x: 0.66, y: 0.34, width: 0.33, height: 0.17),
        CGRect(x: 0.0, y: 0.51, width: 0.33, height: 0.16),
        CGRect(x: 0.33, y: 0.51, width: 0.33, height: 0.16),
        CGRect(x: 0.66, y: 0.51, width: 0.33, height: 0.16)
    ]
    
    override init() {
        super.init()
        setupAudioSession()
        loadPlayers()
        setupCamera()
        setupModel()
        
        $isSongPlaying
                .sink { isPlaying in
                    print("isSongPlaying changed to: \(isPlaying)")
                }
                .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupCamera() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("❌ No front camera found.")
            captureSession.commitConfiguration()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
                videoOutput.connection(with: .video)?.videoOrientation = .portrait
            }
            captureSession.commitConfiguration()
        } catch {
            print("❌ Camera error: \(error.localizedDescription)")
            captureSession.commitConfiguration()
        }
    }
    
    private func setupModel() {
        do {
            self.gestureModel = try MyHandPoseModel5(configuration: MLModelConfiguration())
        } catch {
            fatalError("Failed to load HandPoseModel: \(error.localizedDescription)")
        }
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
        }
    }
    
    private func loadPlayers() {
        for song in songsName {
            if let url = Bundle.main.url(forResource: song, withExtension: "wav") {
                let player = AVPlayer(url: url)
                players.append(player)
            } else {
                print("⚠️ \(song).wav not found in bundle.")
            }
        }
        print("Loaded \(players.count) AVPlayers.")
    }
    
    func startSession() {
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.sampleBuffer = sampleBuffer
        }
        guard !isInferencing else {
            return
        }
        isInferencing = true
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .upMirrored, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else {
                DispatchQueue.main.async { self.handleGesture(pose: nil, fingerPoints: nil) }
                isInferencing = false
                return
            }
            let allPoints = try observation.recognizedPoints(.all)
            let pose = try gestureModel.prediction(poses: observation.keypointsMultiArray())
            DispatchQueue.main.async {
                self.handleGesture(pose: pose.label, fingerPoints: allPoints)
            }
        } catch {
            print("Vision request error: \(error.localizedDescription)")
        }
        isInferencing = false
    }
    
    private func handleGesture(pose: String?, fingerPoints: [VNHumanHandPoseObservation.JointName: VNRecognizedPoint]?) {
        guard let pose = pose else {
            currentGestureCounter = 0
            lastSeenGesture = ""
            currentGesture = ""
            return
        }
        
        if pose == lastSeenGesture {
            currentGestureCounter += 1
        } else {
            currentGestureCounter = 0
            lastSeenGesture = pose
        }
        guard currentGestureCounter >= requiredConfidenceCount else {
            return
        }
        if (pose == "Peace" || pose == "Point Right" || pose == "Point Left") && pose == currentGesture {
            return
        }
        currentGesture = pose
        print("ACTION TRIGGERED: \(pose)")
        
        if pose == "Fist" {
            currentPlayer?.pause()
            DispatchQueue.main.async {
                self.isSongPlaying = false
            }
            updateNowPlayingInfoPlaybackState()
            return
        } else if pose == "Palm" {
            currentPlayer?.play()
            DispatchQueue.main.async {
                self.isSongPlaying = true
            }
            updateNowPlayingInfoPlaybackState()
            return
        }
        guard (pose == "Peace" || pose == "Point Right" || pose == "Point Left"),
              let fingerPoints = fingerPoints,
              let fingerTip = fingerPoints[.indexTip],
              fingerTip.confidence > 0.3 else { return }
        
        let normalizedPoint = CGPoint(x: fingerTip.location.x, y: 1.0 - fingerTip.location.y)
        for (index, zone) in gridZones.enumerated() {
            if zone.contains(normalizedPoint) {
                if lastPlayedTrack == index { return }
                print("▶️ Playing Track \(index + 1)")
                play(index: index)
                lastPlayedTrack = index
                return
            }
        }
    }
    
    func play(index: Int) {
        
        currentPlayer?.pause()

        
        if let observer = timeObserver, let oldPlayer = timeObserverOwner {
            oldPlayer.removeTimeObserver(observer)
            timeObserver = nil
            timeObserverOwner = nil
        }

        
        currentPlayer = players[index]
        guard let player = currentPlayer else { return }

        player.seek(to: .zero)
        player.play()

        self.currentSong = self.songsName[index]
        self.songName = self.currentSong
        self.artistName = self.artist(for: self.currentSong)
        self.imageName = self.currentSong
        self.isSongPlaying = true

        DispatchQueue.main.async {
            self.updateNowPlayingInfo()
        }

        addTimeObserver()
    }
    
    private func addTimeObserver() {
        if let observer = timeObserver, let oldPlayer = timeObserverOwner {
            oldPlayer.removeTimeObserver(observer)
            timeObserver = nil
            timeObserverOwner = nil
        }
        
        guard let player = currentPlayer else { return }

        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1),
                                                      queue: .main) { [weak self] time in
            guard let self = self else { return }
            var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
            let duration = player.currentItem?.asset.duration ?? .zero
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(time)
            info[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
            info[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }

        timeObserverOwner = player
    }
    
    private func updateNowPlayingInfo() {
        DispatchQueue.main.async {
            var info: [String: Any] = [
                MPMediaItemPropertyTitle: self.currentSong,
                MPMediaItemPropertyArtist: self.artistName,
                MPNowPlayingInfoPropertyPlaybackRate: self.currentPlayer?.rate ?? (self.isSongPlaying ? 1.0 : 0.0)
            ]

            if let player = self.currentPlayer,
               let duration = player.currentItem?.asset.duration {
                let dur = CMTimeGetSeconds(duration)
                if dur.isFinite && dur > 0 {
                    info[MPMediaItemPropertyPlaybackDuration] = dur
                }
            }

            if !self.imageName.isEmpty, let uiImage = UIImage(named: self.imageName) {
                info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: uiImage.size) { _ in uiImage }
            } else {
                if let placeholder = UIImage(named: "AlbumPlaceholder") {
                    info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: placeholder.size) { _ in placeholder }
                } else {
                    print("⚠️ updateNowPlayingInfo: artwork not found for '\(self.imageName)' / '\(self.currentSong)'")
                }
            }
            if let player = self.currentPlayer {
                let elapsed = player.currentTime()
                info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(elapsed)
                info[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
            }

            MPNowPlayingInfoCenter.default().nowPlayingInfo = info

            self.setupRemoteCommandCenter()
        }
    }

    
    private func updateNowPlayingInfoPlaybackState() {
        guard let player = currentPlayer else { return }
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        if let currentTime = player.currentItem?.currentTime() {
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(currentTime)
        }
        info[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    private func setupRemoteCommandCenter() {
        guard !isRemoteHandlersRegistered else { return }
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.currentPlayer?.play()
            self?.updateNowPlayingInfoPlaybackState()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.currentPlayer?.pause()
            self?.updateNowPlayingInfoPlaybackState()
            return .success
        }
        isRemoteHandlersRegistered = true
    }
    
    func artist(for song: String) -> String {
        switch song {
        case "Espresso": return "Sabrina Carpenter"
        case "Closer": return "The Chainsmokers"
        case "Attention": return "Charlie Puth"
        case "We Don't Talk Anymore": return "Charlie Puth"
        case "Like I Do": return "J.Taylor"
        case "I Like Me Better": return "Lauv"
        case "Infinity": return "Jaymes Young"
        case "Can We Kiss Forever?": return "Kina"
        case "Royalty": return "Egzod"
        default: return ""
        }
    }
}
