import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../core/constants.dart';

class QuizRepository {
  static final QuizRepository _instance = QuizRepository._internal();
  factory QuizRepository() => _instance;
  QuizRepository._internal();

  SharedPreferences? _prefs;
  List<Quiz> _cachedQuizzes = [];
  UserProgress? _cachedProgress;

  // Initialize the repository
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadQuizzes();
    await _loadUserProgress();
  }

  // Load all quizzes from assets
  Future<void> _loadQuizzes() async {
    try {
      _cachedQuizzes.clear();
      
      // Load each category's quiz data
      for (String category in AppConstants.categories) {
        try {
          final fileName = _getFileNameForCategory(category);
          final jsonString = await rootBundle.loadString('${AppConstants.quizDataPath}$fileName');
          final jsonData = json.decode(jsonString);
          
          if (jsonData is Map<String, dynamic>) {
            final quiz = Quiz.fromJson(jsonData);
            _cachedQuizzes.add(quiz);
          } else if (jsonData is List) {
            // Handle multiple quizzes in one file
            for (var quizData in jsonData) {
              final quiz = Quiz.fromJson(quizData);
              _cachedQuizzes.add(quiz);
            }
          }
        } catch (e) {
          print('Error loading quiz for category $category: $e');
          // Continue loading other categories
        }
      }
    } catch (e) {
      print('Error loading quizzes: $e');
      throw Exception('Failed to load quiz data');
    }
  }

  String _getFileNameForCategory(String category) {
    return '${category.toLowerCase().replaceAll(' ', '_')}.json';
  }

  // Get all available categories
  Future<List<String>> getCategories() async {
    if (_cachedQuizzes.isEmpty) {
      await _loadQuizzes();
    }
    
    final categories = _cachedQuizzes
        .map((quiz) => quiz.category)
        .toSet()
        .toList();
    
    categories.sort();
    return categories;
  }

  // Get quiz by category
  Future<Quiz?> getQuizByCategory(String category) async {
    if (_cachedQuizzes.isEmpty) {
      await _loadQuizzes();
    }
    
    try {
      return _cachedQuizzes.firstWhere(
        (quiz) => quiz.category.toLowerCase() == category.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get all quizzes
  Future<List<Quiz>> getAllQuizzes() async {
    if (_cachedQuizzes.isEmpty) {
      await _loadQuizzes();
    }
    return List.from(_cachedQuizzes);
  }

  // Get random questions from a category
  Future<List<Question>> getRandomQuestions(
    String category, 
    int count,
  ) async {
    final quiz = await getQuizByCategory(category);
    if (quiz == null) return [];

    final questions = List<Question>.from(quiz.questions);
    questions.shuffle();
    
    return questions.take(count).toList();
  }

  // Save quiz result
  Future<void> saveQuizResult(QuizResult result) async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      // Get existing results
      final resultsJson = _prefs!.getStringList('quiz_results') ?? [];
      final results = resultsJson
          .map((json) => QuizResult.fromJson(jsonDecode(json)))
          .toList();

      // Add new result
      results.add(result);

      // Keep only last 50 results to prevent storage bloat
      if (results.length > 50) {
        results.removeRange(0, results.length - 50);
      }

      // Save back to preferences
      final updatedResultsJson = results
          .map((result) => jsonEncode(result.toJson()))
          .toList();
      
      await _prefs!.setStringList('quiz_results', updatedResultsJson);

      // Update cached progress
      await _updateUserProgress(result);
    } catch (e) {
      print('Error saving quiz result: $e');
      throw Exception('Failed to save quiz result');
    }
  }

  // Update user progress
  Future<void> _updateUserProgress(QuizResult result) async {
    if (_cachedProgress == null) {
      _cachedProgress = UserProgress(
        userId: 'default_user',
        categoryScores: {},
        recentResults: [],
        totalQuizzesTaken: 0,
        totalQuestionsAnswered: 0,
        totalCorrectAnswers: 0,
        lastUpdated: DateTime.now(),
      );
    }

    // Update category score
    final currentBest = _cachedProgress!.categoryScores[result.category] ?? 0;
    if (result.percentage > currentBest) {
      _cachedProgress!.categoryScores[result.category] = result.percentage.round();
    }

    // Update totals
    _cachedProgress = UserProgress(
      userId: _cachedProgress!.userId,
      categoryScores: _cachedProgress!.categoryScores,
      recentResults: [result, ..._cachedProgress!.recentResults.take(9)],
      totalQuizzesTaken: _cachedProgress!.totalQuizzesTaken + 1,
      totalQuestionsAnswered: _cachedProgress!.totalQuestionsAnswered + result.totalQuestions,
      totalCorrectAnswers: _cachedProgress!.totalCorrectAnswers + result.correctAnswers,
      lastUpdated: DateTime.now(),
    );

    // Save to preferences
    await _saveUserProgress();
  }

  // Load user progress
  Future<UserProgress?> loadUserProgress() async {
    if (_cachedProgress != null) return _cachedProgress;
    return await _loadUserProgress();
  }

  Future<UserProgress?> _loadUserProgress() async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      final progressJson = _prefs!.getString(AppConstants.progressKey);
      if (progressJson != null) {
        _cachedProgress = UserProgress.fromJson(jsonDecode(progressJson));
        return _cachedProgress;
      }
    } catch (e) {
      print('Error loading user progress: $e');
    }
    return null;
  }

  // Save user progress
  Future<void> _saveUserProgress() async {
    if (_prefs == null || _cachedProgress == null) return;

    try {
      final progressJson = jsonEncode(_cachedProgress!.toJson());
      await _prefs!.setString(AppConstants.progressKey, progressJson);
    } catch (e) {
      print('Error saving user progress: $e');
    }
  }

  // Get recent quiz results
  Future<List<QuizResult>> getRecentResults({int limit = 10}) async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      final resultsJson = _prefs!.getStringList('quiz_results') ?? [];
      final results = resultsJson
          .map((json) => QuizResult.fromJson(jsonDecode(json)))
          .toList();

      // Sort by completion date (newest first)
      results.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      return results.take(limit).toList();
    } catch (e) {
      print('Error loading recent results: $e');
      return [];
    }
  }

  // Clear all progress
  Future<void> clearProgress() async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      await _prefs!.remove(AppConstants.progressKey);
      await _prefs!.remove('quiz_results');
      _cachedProgress = null;
    } catch (e) {
      print('Error clearing progress: $e');
      throw Exception('Failed to clear progress');
    }
  }

  // Get app settings
  Future<Map<String, dynamic>> getSettings() async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      final settingsJson = _prefs!.getString(AppConstants.settingsKey);
      if (settingsJson != null) {
        return jsonDecode(settingsJson);
      }
    } catch (e) {
      print('Error loading settings: $e');
    }

    // Return default settings
    return {
      'theme': 'system', // 'light', 'dark', 'system'
      'soundEnabled': true,
      'vibrationEnabled': true,
      'autoNextQuestion': false,
      'showExplanations': true,
    };
  }

  // Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      final settingsJson = jsonEncode(settings);
      await _prefs!.setString(AppConstants.settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
      throw Exception('Failed to save settings');
    }
  }

  // Refresh data (useful for testing or when data changes)
  Future<void> refresh() async {
    await _loadQuizzes();
    await _loadUserProgress();
  }
}


