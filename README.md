# 🎮 TechBoom - Smart Investment Assistant

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Provider-000000?style=for-the-badge&logo=provider&logoColor=white" alt="Provider" />
</p>

## 📌 Project Overview
**TechBoom** is a real-time, interactive multiplayer digital application designed to act as a smart investment assistant and financial manager for the "TechBoom" strategic board game. 

It manages investor balances, calculates production and marketing costs efficiently, and synchronizes game data instantly across all players' devices using a robust cloud architecture.

## 🚀 Key Technical Achievements

- **Real-Time Cloud Architecture:** Engineered a real-time database using **Firebase Firestore** to create game rooms and instantly synchronize player data and financial balances across multiple devices.
- **Secure Authentication:** Implemented user login and profile creation using **Firebase Authentication**, storing specific player data and geographic locations.
- **Dynamic State Management:** Utilized the **Provider** package for highly efficient state management, ensuring smooth UI updates during rapid financial changes and strategic ability usages.
- **Complex Auction Mechanics (TB Actions):** Developed an auction system allowing players to purchase competitive advantages, integrated with strict logical booleans to ensure one-time usage of strategic abilities.
- **Instant Financial Mathematics:** Built a dynamic event system that calculates percentages and applies instant changes (deductions or additions) to the investment capital.
- **Full Localization (RTL/LTR):** Implemented a complete translation system supporting Arabic and English, with automatic layout switching based on the selected language.
- **Immersive UX & Analytics:** Integrated overlapping audio effects (`audioplayers`) linked to in-game events, and built interactive financial charts (`fl_chart`) to track capital history during rounds.
- **Production Ready:** Generated the final `.aab` release with configured digital signatures (Keystore), ready for official publication on the Google Play Store.

## 🛠️ Architecture & Setup

### Prerequisites
- Flutter SDK (Latest Stable Version)
- Dart SDK
- Firebase Project setup (Auth & Firestore)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/hudaabdalmajed3-pixel/TechBoom-App.git
