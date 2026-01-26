# Habitly - Build Better Habits 🚀

Habitly is a modern, elegant habit tracking application built with Flutter. It tracks your daily routines, helps you build consistency, and provides a beautiful, user-friendly interface to manage your goals.

## ✨ Features

- **Modern & Clean UI**
  - Enhanced Start, Login, and Register pages with beautiful wave designs.
- **Habit Management (CRUD)**
  - **Create**: Add new habits with custom titles, categories, and times.
  - **Read**: View your daily tasks filtered by date using the horizontal calendar.
  - **Update**: Edit existing habits easily via the card menu.
  - **Delete**: Remove habits you no longer need.

- **Smart Categorization**
  - Visual icons for categories (Work, Health, Learning, Shopping, etc.).
  - Ability to add **Custom Categories** dynamically.

- **Dark Mode Support 🌙**
  - Fully adaptable to system theme preferences.
  - Optimized color schemes for both Light and Dark modes.

## 🛠 Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Architecture**: Feature-based folder structure
- **State Management**: `setState` (Local State) / MVC Pattern
- **Assets**: Custom SVGs & Images

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/alzahfariski/habitly.git
   ```

2. **Navigate to project directory**

   ```bash
   cd habitly
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── app/                 # App entry point and routing
├── core/                // Core configurations
│   ├── constants/       # App colors, routes, assets
│   ├── themes/          # App theme data (Light/Dark)
│   └── widgets/         # Reusable widgets (Buttons, Clippers)
├── features/            // Feature modules
│   ├── auth/            # Login & Register pages
│   ├── home/            # Home page, Models, Widgets
│   └── intro/           # Start/Onboarding page
└── main.dart            # Main function
```
