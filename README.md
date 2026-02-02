![License](https://img.shields.io/badge/license-MIT-green)
![Flutter SDK](https://img.shields.io/badge/Flutter_SDK-3.38.5-grey?style=flat&labelColor=02569B)

> 📚 **Project Status: MVP Completed.**
> This project was developed as a study case for **Flutter** and **Firebase Realtime**.
> The core gameplay is functional, but there are known technical debts (documented in Issues) regarding architecture and scaling.

 ---

# KnuckleBones
KnuckleBones is a multiplayer dice game developed with Flutter, based on the mechanics of the minigame of the same name featured in Cult of the Lamb, with real-time online matches,
using Firebase Authentication and Cloud Firestore. 

* PS: This project uses Firebase's Spark (free) plan, and some features, not necessarily linked to a paid Firebase plan, have not been implemented 

# 🧩 Some Previews and Features

## Authentication
<p align="center">
  <img src="docs/signin.png" width="300" alt="Sign in screen"/>
  <img src="docs/signup.png" width="300" alt="Sign up screen"/>
</p>

## Lobby and Match
<p align="center">
  <img src="docs/lobby.png" width="300" alt="Lobby screen"/>
  <img src="docs/match.png" width="300" alt="Match screen"/>
</p>

# 📖 How to Play
Check out the [**Rules & Scoring Mechanics**](docs/GAME_RULES.md)

# 🧰 Toolbox

<p align="center">
  <a href="https://skillicons.dev">
    <img src="https://skillicons.dev/icons?i=flutter,firebase,androidstudio,git" />
  </a>
</p>
<br/>

# 🚀 How to Run

## Prerequisites
- Firebase project
- Android SDK or physical Android device
- **FVM installed** (used to manage the Flutter SDK version)

> This project uses FVM to ensure the correct Flutter SDK version.  
> All Flutter commands should be executed via FVM.

## 1. Clone the repository

```
 git clone https://github.com/VorAd2/knuckle-bones
 cd knuckle-bones
```

## 2. Create a Firebase project and install Firebase SDK
- <a href='https://console.firebase.google.com'> Firebase Console </a>
- <a href='https://firebase.google.com/docs/flutter/setup?platform=android'> Firebase Setup </a>

## 3. Install dependencies

```
fvm flutter pub get
```

## 4. Run !!
Here are two useful links teaching you how to run a Flutter app on mobile devices:
- <a href='https://youtu.be/yxif9Tj8fDE?si=H1UAFWMO05MYUVre'> Physical device </a>
- <a href='https://docs.flutter.dev/platform-integration/android/setup'> Virtual device </a>

<hr/>

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<hr/>

⭐ If you like this project, consider giving it a star!
