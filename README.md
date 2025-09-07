# Quizoria - Offline Quiz & Trivia Game

A beautiful, modern Flutter app for offline quiz and trivia games with Material 3 design.

## Features

### 🎯 Main Features
- **Offline Quizzes**: All quiz data stored locally, no internet required
- **Multiple Categories**: General Knowledge, Science, Sports, and more
- **Smart Scoring**: Detailed score calculation with performance analysis
- **Progress Tracking**: Track your improvement over time
- **Result Summary**: Comprehensive results with explanations

### 📱 Screens
- **Home Screen**: Category selection with beautiful cards
- **Quiz Screen**: Smooth question transitions with progress indicator
- **Result Screen**: Detailed performance analysis
- **Settings Screen**: Theme toggle and app preferences
- **About Screen**: App information and features

### 🎨 Design
- **Material 3**: Modern design with smooth animations
- **Responsive Layout**: Works on phones and tablets
- **Dark/Light Theme**: Toggle between themes with proper color combinations
- **Smooth Animations**: Question transitions and UI interactions
- **Progress Indicators**: Visual feedback during quizzes

### 🏗 Architecture
- **MVVM Pattern**: Clean separation of concerns
- **Repository Pattern**: Centralized data management
- **Provider State Management**: Reactive UI updates
- **Modular Code**: Reusable widgets and components
- **Local Storage**: SharedPreferences for settings and progress

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd quizoria
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── theme/
│   │   └── app_theme.dart   # Material 3 theme configuration
│   └── constants.dart       # App constants and configuration
├── models/
│   └── question.dart        # Data models (Question, Quiz, Result)
├── repository/
│   └── quiz_repository.dart # Data access layer
├── viewmodels/
│   └── quiz_viewmodel.dart  # Business logic and state management
├── views/
│   ├── home_screen.dart     # Category selection screen
│   ├── quiz_screen.dart     # Quiz taking screen
│   ├── result_screen.dart   # Results display screen
│   ├── settings_screen.dart # App settings
│   └── about_screen.dart    # About information
└── widgets/
    ├── question_card.dart   # Question display widget
    ├── option_button.dart   # Answer option widget
    ├── result_summary.dart  # Results summary widget
    └── quiz_progress_indicator.dart # Progress indicator
```

## Quiz Data

Quiz data is stored in JSON format in the `assets/quizzes/` directory:

- `general_knowledge.json` - General knowledge questions
- `science.json` - Science and technology questions  
- `sports.json` - Sports and athletics questions

### Adding New Quizzes

1. Create a new JSON file in `assets/quizzes/`
2. Follow the existing format with questions, options, and explanations
3. Update the categories list in `constants.dart`
4. The app will automatically load the new quiz data

## Customization

### Themes
- Primary Color: Indigo
- Secondary Color: Amber
- Dark theme with proper contrast ratios
- Customizable in `lib/core/theme/app_theme.dart`

### Adding Categories
1. Add category name to `AppConstants.categories`
2. Create corresponding JSON file in `assets/quizzes/`
3. Add category icon mapping in `home_screen.dart`

## Dependencies

- **provider**: State management
- **shared_preferences**: Local storage
- **flutter_animate**: Smooth animations
- **json_annotation**: JSON serialization
- **build_runner**: Code generation

## Future Enhancements

- Timer functionality for questions
- Leaderboard system
- Firebase sync for cloud progress
- More quiz categories
- Difficulty levels
- Sound effects and haptic feedback
- Quiz creation tools

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, feature requests, or bug reports, please open an issue on GitHub.

---

**Quizoria** - Test your knowledge, anytime, anywhere! 🧠✨
