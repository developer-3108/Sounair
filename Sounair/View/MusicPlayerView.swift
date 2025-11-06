//
//  ARView.swift
//  Sounair
//
//  Created by Akshat Srivastava on 06/11/25.
//

import SwiftUI
import AVFoundation
internal import Combine
import MediaPlayer

struct MusicPlayerView: View {
    @StateObject var viewModel = MusicPlayerViewModel()
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.captureSession)
                .blur(radius: 5, opaque: true)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("SOUNAIR")
                            .font(.custom("Bitcount Grid Single", size: 35))
                        Text("music that feels in air")
                            .font(.custom("Nunito", size: 15))
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    Spacer()
                }.padding(.horizontal, 10)
                
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(viewModel.songsName, id: \.self) { song in
                        MusicPlayerGrid(viewModel: viewModel, imageName: song, songName: song, artistName: viewModel.artist(for: song), isPlaying: viewModel.currentSong == song)
                    }
                }.padding(.horizontal, 10)
                
                Spacer()
                
                VStack {
                    MusicVisualizerView(isPlaying: $viewModel.isSongPlaying)
                       .frame(height: 60)
                    
                    VStack {
                        Text("Controls")
                            .font(.custom("Bitcount Grid Single", size: 25))
                        Text("✋ → Play")
                            .font(.custom("Bitcount Grid Single", size: 18))
                        Text("✊ → Pause")
                            .font(.custom("Bitcount Grid Single", size: 18))
                        Text("✌️ → Select Track")
                            .font(.custom("Bitcount Grid Single", size: 18))
                        Text("Detected: \(viewModel.currentGesture)")
                            .font(.custom("Bitcount Grid Single", size: 18))
                            
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(15)
                
            }
        }.foregroundStyle(Color.black)
            .onAppear {
                viewModel.startSession()
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
}

struct MusicVisualizerView: View {
    @Binding var isPlaying: Bool
    @State private var bars: [CGFloat] = Array(repeating: 0.2, count: 50)
    @State private var timer: Timer?
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<30, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.black)
                    .frame(width: 4, height: bars[index] * 60)
            }
        }
        .frame(height: 60)
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
        .onAppear {
            if isPlaying {
                startAnimating()
            }
        }
        .onDisappear {
            stopAnimating()
        }
    }
    
    private func startAnimating() {
        print("Visualizer: Starting animation")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                for i in 0..<bars.count {
                    bars[i] = CGFloat.random(in: 0.3...1.0)
                }
            }
        }
    }
    
    private func stopAnimating() {
        print("Visualizer: Stopping animation")
        timer?.invalidate()
        timer = nil
        withAnimation(.easeInOut(duration: 0.3)) {
            for i in 0..<bars.count {
                bars[i] = 0.2
            }
        }
    }
}

struct MusicPlayerGrid: View {
    @ObservedObject var viewModel: MusicPlayerViewModel
    let imageName: String
    let songName: String
    let artistName: String
    let isPlaying: Bool
    
    var body: some View {
        Button {
            viewModel.songName = songName
            viewModel.artistName = artistName
            viewModel.imageName = imageName
        } label: {
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.7)
                
                VStack{
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(songName)
                                .font(.custom("DM Serif Display", size: 12))
                                .foregroundColor(.white)
                                
                            Text(artistName)
                                .font(.custom("Nunito", size: 9))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        Spacer()
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                }
            }
            .shadow(color: isPlaying ? .cyan : .clear, radius: isPlaying ? 30 : 0)
            .animation(.easeInOut, value: isPlaying)
        }
    }
}

struct CameraPreview: UIViewControllerRepresentable {
    let session: AVCaptureSession
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .black
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        previewLayer.frame = controller.view.bounds
        
        controller.view.layer.addSublayer(previewLayer)
        
        context.coordinator.previewLayer = previewLayer
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.previewLayer?.frame = uiViewController.view.bounds
    }
}


//#Preview {
//    ARView()
//}
