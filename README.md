# Fitness App

A Flutter-based mobile application to track daily fitness activities, set targets, and monitor progress.

## Table of Contents

*   [Features](#features)
*   [Screenshots](#screenshots) (Optional but Recommended)
*   [Tech Stack](#tech-stack)
*   [Project Structure](#project-structure) (Brief Overview)
*   [Setup and Installation](#setup-and-installation)
*   [Usage](#usage)
*   [Contributing](#contributing) (If applicable)
*   [License](#license) (If applicable)

## Features

*   **Activity Tracking:**
    *   Log various activities (e.g., water intake, steps).
    *   View a list of recent activities with timestamps.
    *   Delete logged activities.
*   **Target Setting:**
    *   Set daily targets for water intake (in Liters).
    *   Set daily targets for step count.
*   **Progress Visualization:**
    *   Dashboard view of today's targets and current progress.
    *   (Assumed) Bar chart visualization for activity progress over time.
*   **Data Persistence:**
    *   Targets and activity logs are saved locally on the device using SharedPreferences.
*   **User Interface:**
    *   Clean and intuitive user interface.
    *   Bottom navigation bar for easy access to different sections (Home, Workout, Walking, Profile - inferred from your `button_navigation_bar.dart`).

## Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Language:** [Dart](https://dart.dev/)
*   **State Management:** [Provider](https://pub.dev/packages/provider)
*   **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences)
*   **UI Assets:**
    *   [flutter_svg](https://pub.dev/packages/flutter_svg) for SVG rendering.
    *   [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) for icons.
*   **Charting:** (Mention the charting library used for `BarChartProgress` if it's a specific package, e.g., fl_chart)
*   **Linting/Formatting:** (Mention if you use specific lint rules or Dart format)

    
