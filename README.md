#Video Link: 
https://drive.google.com/file/d/1-dbXcl8-VTgliFVNdTtvfi05FyMI4nOV/view?usp=sharing

# Chess-Game

A cross-platform Chess game built using Flutter and Dart.

## Features

- **Play With Friend:** Challenge a friend on the same device in a classic chess match.
- **Play With Computer:** Play against a computer opponent.
- **Full Chess Logic:** Implements all piece movements, captures, check, and checkmate.
- **Move History:** View and track the history of all moves played in a game.
- **Captured Pieces:** Displays captured pieces for both black and white sides.
- **Visual Chess Board:** Interactive chessboard with pieces.
- **Game Persistence:** Supports saving and syncing games using Firestore (Firebase).
- **User Profiles & Stats:** Includes user profiles and tracks game statistics (requires Firebase Auth).

## Technologies Used

- **Dart**: Main programming language.
- **Flutter**: Cross-platform app framework.
- **Firebase (Firestore & Auth)**: For user authentication, game storage, and real-time updates.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart (included with Flutter)
- A Firebase project (for Firestore and Auth features)

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/xufr5h/Chess-Game.git
   cd Chess-Game
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Setup Firebase:**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Add Firebase for your platform(s) (Android/iOS/Web).
   - Download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) and place it in the respective directory.
   - Enable Firestore and Authentication in your Firebase console.

4. **Run the app:**
   ```sh
   flutter run
   ```

### Building for Windows

This app supports desktop (Windows) via Flutter. To build for Windows:
```sh
flutter build windows
```

## Usage

- Choose a game mode: Play with Friend or Play with Computer.
- Make moves by tapping pieces.
- The app will indicate turn, check, and checkmate.


