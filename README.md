# Habitly - Build Better Habits 🚀

Habitly is a modern, elegant habit tracking application built with Flutter. It tracks your daily routines, helps you build consistency, and provides a beautiful, user-friendly interface to manage your goals.

## ✨ Features

- **Modern & Clean UI**
  - Enhanced Start, Login, and Register pages with beautiful wave designs.
  - "Hello" Dashboard with profile summary.
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

## 📱 Screenshots

|                     Light Mode                     |                    Dark Mode                     |
| :------------------------------------------------: | :----------------------------------------------: |
|  ![Home Light](assets/screenshots/home_light.png)  |  ![Home Dark](assets/screenshots/home_dark.png)  |
| ![Login Light](assets/screenshots/login_light.png) | ![Login Dark](assets/screenshots/login_dark.png) |

_(Note: Add your screenshots to `assets/screenshots/`)_

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
   git clone https://github.com/username/habitly.git
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

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.
