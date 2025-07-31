# 🏋️‍♂️ Fitness Tracker App

A **Flutter-based mobile application** designed to help users monitor daily fitness goals, track activities such as water intake and steps, and visualize their progress in a clean and user-friendly interface.

---



## 🚀 Features

### ✅ Activity Tracking
- Log daily activities (e.g., water intake).
- Display a timeline of recent actions.
- Delete individual activities.

### 🎯 Goal Setting
- Set daily hydration targets (in ml or liters).
- Set step-count goals.

### 📊 Progress Visualization
- Visual dashboard showing today’s progress.
- Bar chart progress tracking (uses [`fl_chart`](https://pub.dev/packages/fl_chart)).

### 💾 Local Data Persistence
- Activities and targets stored using `SharedPreferences`.
- Data persists even after app restart.

### 🖌️ User Interface
- Modern, intuitive design.
- Smooth navigation via bottom navigation bar.
- Consistent styling and spacing.

---

## 🧰 Tech Stack

| Layer             | Technology                                |
|------------------|--------------------------------------------|
| Framework         | [Flutter](https://flutter.dev/)           |
| Language          | [Dart](https://dart.dev/)                 |
| State Management  | [Provider](https://pub.dev/packages/provider) |
| Storage           | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| SVG Rendering     | [flutter_svg](https://pub.dev/packages/flutter_svg) |
| Icon Support      | [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) |
| Charting          | [fl_chart](https://pub.dev/packages/fl_chart) |
| IDE               | Visual Studio Code / Android Studio       |

---

## ⚙️ Setup and Installation

```bash
git clone https://github.com/yourusername/fitness_app.git
cd fitness_app
flutter pub get
flutter run
