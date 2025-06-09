# Fundusnap

Fundusnap is a modern mobile application designed to capture and analyze fundus images using advanced technology. The app provides a seamless experience for healthcare professionals to capture, store, and manage fundus images with high precision and ease.

## Features

- 📸 High-quality fundus image capture
- 🎥 Video recording capabilities
- 🔒 Secure storage of medical images
- 📱 Cross-platform support (iOS, Android)
- 🎨 Modern and intuitive user interface
- 🔐 Secure authentication and data protection

### AI-Powered Analysis
- 🔍 Automated Diabetic Retinopathy (DR) staging using Azure Custom Vision
- 📱 Support for both live camera capture and existing image files
- 📊 Probability-based classification of DR stages:
  - Moderate NPDR (Non-Proliferative Diabetic Retinopathy)
  - PDR (Proliferative Diabetic Retinopathy)
  - Severe NPDR
  - Advanced PDR
  - No DR
  - Mild/Early NPDR

### Intelligent Chatbot Assistant
- 💬 AI-powered chatbot using Microsoft MAI DS R1 model through OpenRouter.ai
- 📝 Contextual explanations of analysis results
- 🔄 Interactive chat sessions linked to specific test results
- 💡 Detailed insights and clarifications about DR stages
- 📱 Seamless chat interface for follow-up questions

## Tech Stack

### Core Technologies
- **Framework**: Flutter (SDK ^3.8.0)
- **Language**: Dart
- **State Management**: Flutter Bloc
- **Navigation**: Go Router

### Key Dependencies
- **Camera**: `camera: ^0.11.1` - For capturing high-quality fundus images
- **Video Player**: `video_player: ^2.9.5` - For video playback functionality
- **Secure Storage**: `flutter_secure_storage: ^9.2.4` - For secure data storage
- **Image Picker**: `image_picker: ^1.1.2` - For image selection and management
- **HTTP Client**: `dio: ^5.8.0+1` - For network requests
- **UI Components**: 
  - `google_fonts: ^6.2.1` - For typography
  - `gap: ^3.0.1` - For layout spacing
  - `cupertino_icons: ^1.0.8` - For iOS-style icons

### Development Tools
- **Linting**: Flutter Lints
- **Splash Screen**: Flutter Native Splash
- **App Icons**: Flutter Launcher Icons

## Getting Started

### Prerequisites
- Flutter SDK (^3.8.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code (recommended IDE)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── assets/
│   ├── images/
│   └── logos/
├── android/
├── ios/
├── web/
├── windows/
├── linux/
└── macos/
```