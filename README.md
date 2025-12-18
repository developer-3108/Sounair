
# Sounair - Where Music Floats in Air

**Sounair** is a futuristic concept app that lets you **control music without touching your screen** — just through your hand gestures and hover movement in the air.  
Built using **SwiftUI**, **CoreML**, **Vision**, and **AVFoundation**, it’s a touchless experience that reimagines how we interact with sound.

> *“Others play music. We conduct it.”*

---

## 🚀 Concept Overview

In a world still tapping screens, **Sounair** explores a new form of interaction —  
**gesture and hover-based music control**.  
It’s not just an app. It’s a concept prototype that shows what the future of music control could look like. This project also demontrates advanced integration of the iOS technologies (Vision, Dynamic Island, Background Audio) into a single, polished user experience.

---

## ✨ Key Features

- 🖐️ **Touchless Gesture Control** — Play, pause, or switch tracks just by showing gestures like palm, fist, or finger swipes.  
- 🪶 **Hover-Based Music Selection** — Hover your fingers above track tiles to instantly play that song.  
- ⚙️ **Customizable Gestures** — Assign your preferred gesture to different controls (planned feature).  
- 🎵 **Real-Time Music Playback** — Powered by `AVFoundation` for seamless audio experience.  
- 🎨 **Minimal, Fluid UI** — Inspired by Apple’s design language — smooth animations, depth, and light.  
- 🧠 **Powered by AI** — Gesture recognition model trained using **Create ML** for real-time classification.  
- 🔊 **Dynamic Feedback** — Subtle animations and visual cues that make the air come alive.  
- 📱 **Dynamic Island Integration** - See the currently playing track at a glance in the Dynamic Island.
- 🎛️ **Background Play** -  Music continues to play even when the app is closed or the phone is locked.

---

## 🧩 Tech Stack

| Technology | Purpose |
|-------------|----------|
| **SwiftUI** | For building the modern, declarative UI |
| **CoreML** | For gesture recognition using a custom-trained ML model |
| **Vision Framework** | To process live hand tracking and classification |
| **AVFoundation** | To handle music playback and media control |
| **Create ML** | Used for training the custom gesture classification model |

---

## 🧠 How It Works

Sounair's core logic is an elegant integration of three main components:

1. **Camera Feed (AVCaptureSession)** - A live video feed is captured from the front-facing camera.
2. **Vision Hand Pose Request (VNDetectHumanHandPoseRequest)** -  Each frame from the camera is analyzed by the Vision framework, which detects the presence and pose of a hand in real-time.
3. **Action Dispatcher** - When a specific gesture (like ✊ or ✌️) is detected with a high confidence score, the app triggers the corresponding action (e.g., AudioPlayer.play(), AudioPlayer.pause()).

> Everything happens **on-device**, keeping it smooth and private.

---

## 🖼️ Demo Preview

Demo Video Link: [Google Drive](https://drive.google.com/file/d/1yyoIn4iibpGMoFwahaeF6UkOccwl3tP1/view?usp=sharing)

<img src="https://github.com/user-attachments/assets/75896f54-f7de-4bb6-995d-c45200958a37" alt="Home Page Screenshot" width="300"/>

<img src="https://github.com/user-attachments/assets/195dcad7-1fce-4e10-84e9-d77326ec3e28" alt="Home Page Screenshot" width="300"/>

---

## 🔮 Future Improvements

- Custom gesture mapping for personalized controls.  
- Gesture calibration & sensitivity settings.  
- Integration with **hover-based typing** for playlist search.  
- Dynamic, beat-synced background animations.  
- AR mode for 3D spatial gesture control.

---

## 💭 The Emotion Behind Sounair

This one’s close to me.  
When I first thought about **Sounair**, it sounded like one of those “bro, that’s impossible” ideas.  
I didn’t even know where to start. But I had this one stupidly ambitious thought — *“what if I could play music in air?”*  
Fast-forward a few nights, hundreds of print statements, one CoreML model, and at least three nervous breakdowns later — **it works**.

And honestly? It’s fun as hell.

Most apps brag about their “premium audio quality.”  
Cool, bro. You upgraded your bass.  
Meanwhile, I’m out here **controlling songs mid-air** like a budget Tony Stark.  
No subscriptions, no “Pro version”, no ads asking you to sell your kidney for dark mode — just you, your hand, and pure futuristic chaos.

The idea came from real life —  
You’re cooking, hands covered in masala, Siri’s acting like she’s on vacation, and you just want to hear your track.  
Or you’re driving, and instead of awkwardly unlocking your phone while praying for your life, you just wave your hand — boom, next song.  
Sometimes innovation is just **laziness disguised as genius.**

And yeah, **Sounair** might be a concept project, but it’s not fiction. It *actually* works.  
You can call it “AI”, “ML”, or just “magic with a dash of caffeine.”  
All I know is — while other apps are stuck selling “hi-fi sound,” I’m literally **making sound fly.**

So here’s to **Sounair** — built with frustration, sarcasm, and a bit of that “cool developer energy.”  
Because touching screens? That’s so last decade.

## 🏷️ Credits

**Developed by:** [Akshat Srivastava](https://www.linkedin.com/in/akshat-srivastava07/)  
**Made with:** SwiftUI • CoreML • Vision • AVFoundation  


---

## 📣 Connect

If you liked the project, drop a ⭐ on GitHub or share your thoughts on [LinkedIn](https://linkedin.com/in/akshatsriv07). You can also follow me on [X](https://x.com/developer_3108).Let’s redefine how we listen, one gesture at a time. 

☕️ Support the madness (and my coffee bill): [https://razorpay.me/@akshatsriv_07](https://razorpay.me/@akshatsriv_07)

---

### 🪄 Tagline
> **Sounair — Where Music Floats in Air.**
