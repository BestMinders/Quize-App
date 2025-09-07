class AppConstants {
  // App Info
  static const String appName = 'Quizoria';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Offline Quiz & Trivia Game';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String progressKey = 'quiz_progress';
  static const String settingsKey = 'app_settings';
  
  // Quiz Categories
  static const List<String> categories = [
    'General Knowledge',
    'Science',
    'Sports',
  ];
  
  // Quiz Settings
  static const int defaultTimePerQuestion = 30; // seconds
  static const int maxQuestionsPerQuiz = 10;
  static const int minQuestionsPerQuiz = 5;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // API/Data
  static const String quizDataPath = 'assets/quizzes/';
  static const String defaultQuizFile = 'general_knowledge.json';
  
  // Score Thresholds
  static const int excellentScore = 90;
  static const int goodScore = 70;
  static const int averageScore = 50;
  
  // Error Messages
  static const String networkError = 'Network connection error';
  static const String dataError = 'Failed to load quiz data';
  static const String unknownError = 'An unknown error occurred';
  
  // Success Messages
  static const String quizCompleted = 'Quiz completed successfully!';
  static const String progressSaved = 'Progress saved successfully';
}


