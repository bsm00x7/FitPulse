# 🏋️‍♂️ Fitness Tracker App

A comprehensive **Flutter-based mobile fitness application** designed to help users achieve their health and wellness goals. Track your daily activities, monitor progress, manage sleep patterns, calculate BMI, and stay motivated with an intuitive and modern interface.

---

## ✨ Features

### 🏃‍♂️ Activity Tracking
- **Step Counter**: Real-time pedometer integration to track daily steps
- **Walking Sessions**: Log and monitor walking activities with duration and distance
- **Water Intake**: Track daily hydration levels and set personalized goals
- **Activity Timeline**: View a comprehensive history of all logged activities
- **Progress Streaks**: Track consecutive days of meeting your goals

### 😴 Sleep Monitoring
- **Sleep Tracking**: Log sleep duration and quality
- **Sleep Analysis**: Visualize sleep patterns and trends
- **Sleep Quality Rating**: Rate and track sleep quality over time
- **Sleep Statistics**: View average sleep duration and insights

### 📊 Health Metrics
- **BMI Calculator**: Calculate and track Body Mass Index
- **Weight Tracking**: Monitor weight changes over time
- **Height Management**: Update and maintain height records
- **Progress Charts**: Visual representation of health metrics using interactive charts

### 🎯 Goal Management
- **Daily Targets**: Set personalized daily goals for steps, water, and calories
- **Goal Tracking**: Monitor progress toward daily and weekly objectives
- **Achievement System**: Earn achievements for consistency and milestones
- **Custom Goals**: Create custom fitness targets based on personal needs

### 👤 Profile & Settings
- **User Profile**: Manage personal information and preferences
- **Workout Progress**: Track workout history and improvements
- **Contact Support**: Easy access to support and feedback options
- **Settings**: Customize app preferences and notifications

### 🎨 User Experience
- **Modern UI/UX**: Clean, intuitive design with smooth animations
- **Dark Mode Support**: Eye-friendly interface for all lighting conditions
- **Responsive Design**: Optimized for various screen sizes
- **Haptic Feedback**: Tactile responses for better user interaction
- **Pull-to-Refresh**: Easily update data with gesture controls
- **Glassmorphism Effects**: Modern visual aesthetics with blur effects

---

## 🧰 Tech Stack

| Category          | Technology                                                      |
|-------------------|-----------------------------------------------------------------|
| **Framework**     | [Flutter](https://flutter.dev/) 3.x                            |
| **Language**      | [Dart](https://dart.dev/)                                       |
| **State Management** | [GetX](https://pub.dev/packages/get)                        |
| **Local Storage** | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| **Charts**        | [fl_chart](https://pub.dev/packages/fl_chart)                  |
| **Icons**         | [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) |
| **SVG Support**   | [flutter_svg](https://pub.dev/packages/flutter_svg)            |
| **Step Counter**  | [pedometer](https://pub.dev/packages/pedometer)                |
| **Permissions**   | [permission_handler](https://pub.dev/packages/permission_handler) |

---

## 📁 Project Structure

```
fitness_app/
├── lib/
│   ├── core/
│   │   ├── features/
│   │   │   ├── home/              # Home screen & widgets
│   │   │   │   ├── widgets/       # BMI, targets, app bar components
│   │   │   │   └── home.dart
│   │   │   ├── profile/           # User profile screens
│   │   │   ├── activity/          # Activity tracking features
│   │   │   ├── sleep/             # Sleep monitoring
│   │   │   ├── walking/           # Walking tracker
│   │   │   └── auth/              # Authentication related screens and logic
│   │   ├── models/                # Data models
│   │   ├── controllers/           # State management controllers
│   │   └── utils/                 # Helper functions & constants
│   └── main.dart
├── assets/
│   ├── images/                    # Image assets
│   └── icons/                     # SVG and icon files
├── android/                       # Android-specific configuration
├── ios/                           # iOS-specific configuration
└── pubspec.yaml                   # Dependencies & project config
```

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- **Flutter SDK** (3.0 or higher): [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**: [Install Git](https://git-scm.com/downloads)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fitness_app.git
   cd fitness_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Flutter setup**
   ```bash
   flutter doctor
   ```
   Fix any issues reported by Flutter Doctor before proceeding.

4. **Run the app**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS (macOS only):
   ```bash
   flutter run -d ios
   ```
   
   For a specific device:
   ```bash
   flutter devices                    # List available devices
   flutter run -d <device-id>         # Run on specific device
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

---

## 🎯 Usage

### First-Time Setup
1. Open the app and navigate to the **Profile** screen
2. Enter your personal details (height, weight, age)
3. Set your daily goals (steps, water intake, calories)
4. Grant necessary permissions (Activity Recognition for step counting)

### Daily Usage
- **Track Steps**: Steps are counted automatically in the background
- **Log Water**: Tap the water icon on the home screen to log intake
- **Record Sleep**: Use the sleep tracker to log your sleep duration
- **Monitor Progress**: View your daily progress on the home dashboard
- **Check BMI**: Calculate and track your BMI from the home screen

---

## 📱 Permissions

This app requires the following permissions:

- **Activity Recognition** (Android): For step counting
- **Physical Activity** (iOS): For step counting
- **Storage**: For caching data (handled automatically)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 🐛 Known Issues & Future Enhancements

### Known Issues
- None currently reported

### Planned Features
- [ ] Social sharing of achievements
- [ ] Workout plans and exercises library
- [ ] Nutrition tracking
- [ ] Integration with wearables (Fitbit, Apple Watch)
- [ ] Cloud sync across devices
- [ ] Weekly/Monthly reports

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Authors

**Bassem** - *Initial work*

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All open-source package contributors
- The fitness and health community for inspiration

---

## 📞 Support

If you encounter any issues or have questions:
- Open an issue on GitHub
- Contact: [bassemnaser124@gmail.com]

---

**Made with ❤️ and Flutter**
