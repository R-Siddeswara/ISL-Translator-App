# Indian Sign Language (ISL) Translator App

An AI-powered mobile application designed to facilitate communication between hearing and non-hearing users by translating Indian Sign Language into speech and converting spoken input into sign-based visual interaction.

## 📌 Overview

Communication can be challenging for individuals who use sign language when interacting with people who do not understand it. The Indian Sign Language Translator App aims to bridge this communication gap through a mobile-based translation system.

The application uses the device camera to capture sign language gestures and processes them using a machine learning model to identify the corresponding signs. The recognized signs can then be converted into spoken output using text-to-speech technology.

The application also supports the reverse communication flow, allowing spoken input to be converted into a sign-based visual representation using 3D models.

## ✨ Key Features

- 📷 Real-time camera-based sign recognition
- 🤟 Indian Sign Language gesture translation
- 🔊 Sign-to-speech conversion
- 🎙️ Speech-to-sign interaction
- 🧑‍💻 Interactive 3D model representation
- 📱 Cross-platform mobile application
- ⚡ TensorFlow Lite-based on-device inference
- 🔄 Two-way communication support

## 🔄 Communication Flow

### Sign → Speech

```text
Camera
   ↓
Sign Language Gesture
   ↓
Image Processing
   ↓
TensorFlow Lite Model
   ↓
Recognized Sign
   ↓
Text
   ↓
Text-to-Speech
   ↓
Audio Output
