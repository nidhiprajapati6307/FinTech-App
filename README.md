# FinTech App

A Flutter FinTech application with authentication, dashboard, and profile using Firebase.

## Setup

1. Clone repository
2. Create a Firebase project
3. Enable Email/Password and Phone Authentication
4. Create a Firestore database and add a `users` collection
5. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
6. Run `flutter pub get`
7. Run `flutter run`

## Architecture

- **State Management**: Riverpod
- **Navigation**: GoRouter (redirect based on auth state)
- **Backend**: Firebase Auth + Firestore
- **Clean Architecture** with feature-first structure

## Screens

- Splash → Onboarding → Login/Register → OTP Verification → Dashboard → Profile

## Color Scheme

Blue (#1A3B5C), White, Gold (#D4AF37)

