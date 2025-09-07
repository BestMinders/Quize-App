import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../repository/quiz_repository.dart';

enum QuizState {
  loading,
  ready,
  inProgress,
  completed,
  error,
}

class QuizViewModel extends ChangeNotifier {
  final QuizRepository _repository = QuizRepository();

  // State
  QuizState _state = QuizState.loading;
  String? _errorMessage;
  String? _selectedCategory;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  List<int> _selectedAnswers = [];
  List<QuestionResult> _questionResults = [];
  DateTime? _quizStartTime;
  DateTime? _questionStartTime;
  Duration _totalTimeTaken = Duration.zero;
  QuizResult? _quizResult;

  // Getters
  QuizState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _questions.length;
  Question? get currentQuestion => 
      _currentQuestionIndex < _questions.length ? _questions[_currentQuestionIndex] : null;
  List<int> get selectedAnswers => _selectedAnswers;
  bool get isLastQuestion => _currentQuestionIndex >= _questions.length - 1;
  bool get isFirstQuestion => _currentQuestionIndex == 0;
  double get progress => totalQuestions > 0 ? (_currentQuestionIndex + 1) / totalQuestions : 0.0;
  QuizResult? get quizResult => _quizResult;
  Duration get totalTimeTaken => _totalTimeTaken;

  // Initialize the view model
  Future<void> initialize() async {
    try {
      _setState(QuizState.loading);
      await _repository.initialize();
      _setState(QuizState.ready);
    } catch (e) {
      _setError('Failed to initialize: $e');
    }
  }

  // Load categories
  Future<List<String>> loadCategories() async {
    try {
      return await _repository.getCategories();
    } catch (e) {
      _setError('Failed to load categories: $e');
      return [];
    }
  }

  // Start a new quiz
  Future<void> startQuiz(String category, {int questionCount = 10}) async {
    try {
      _setState(QuizState.loading);
      _selectedCategory = category;
      
      // Get random questions from the category
      _questions = await _repository.getRandomQuestions(category, questionCount);
      
      if (_questions.isEmpty) {
        throw Exception('No questions available for this category');
      }

      // Initialize quiz state
      _currentQuestionIndex = 0;
      _selectedAnswers = List.filled(_questions.length, -1);
      _questionResults = [];
      _quizStartTime = DateTime.now();
      _questionStartTime = DateTime.now();
      _totalTimeTaken = Duration.zero;
      _quizResult = null;

      _setState(QuizState.inProgress);
    } catch (e) {
      _setError('Failed to start quiz: $e');
    }
  }

  // Select an answer for the current question
  void selectAnswer(int answerIndex) {
    if (_state != QuizState.inProgress || currentQuestion == null) return;
    
    _selectedAnswers[_currentQuestionIndex] = answerIndex;
    notifyListeners();
  }

  // Move to next question
  Future<void> nextQuestion() async {
    if (_state != QuizState.inProgress || isLastQuestion) return;

    // Record time spent on current question
    if (_questionStartTime != null) {
      final timeSpent = DateTime.now().difference(_questionStartTime!);
      _recordQuestionResult(timeSpent);
    }

    _currentQuestionIndex++;
    _questionStartTime = DateTime.now();
    notifyListeners();
  }

  // Move to previous question
  void previousQuestion() {
    if (_state != QuizState.inProgress || isFirstQuestion) return;

    // Record time spent on current question
    if (_questionStartTime != null) {
      final timeSpent = DateTime.now().difference(_questionStartTime!);
      _recordQuestionResult(timeSpent);
    }

    _currentQuestionIndex--;
    _questionStartTime = DateTime.now();
    notifyListeners();
  }

  // Complete the quiz
  Future<void> completeQuiz() async {
    if (_state != QuizState.inProgress) return;

    try {
      // Record time spent on current question
      if (_questionStartTime != null) {
        final timeSpent = DateTime.now().difference(_questionStartTime!);
        _recordQuestionResult(timeSpent);
      }

      // Calculate total time taken
      if (_quizStartTime != null) {
        _totalTimeTaken = DateTime.now().difference(_quizStartTime!);
      }

      // Calculate results
      final correctAnswers = _questionResults.where((result) => result.isCorrect).length;
      final wrongAnswers = _questionResults.length - correctAnswers;
      final percentage = _questionResults.isNotEmpty 
          ? (correctAnswers / _questionResults.length) * 100 
          : 0.0;

      // Create quiz result
      _quizResult = QuizResult(
        quizId: '${_selectedCategory}_${DateTime.now().millisecondsSinceEpoch}',
        category: _selectedCategory ?? 'Unknown',
        totalQuestions: _questionResults.length,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
        percentage: percentage,
        timeTaken: _totalTimeTaken,
        completedAt: DateTime.now(),
        questionResults: List.from(_questionResults),
      );

      // Save result to repository
      await _repository.saveQuizResult(_quizResult!);

      _setState(QuizState.completed);
    } catch (e) {
      _setError('Failed to complete quiz: $e');
    }
  }

  // Record result for current question
  void _recordQuestionResult(Duration timeSpent) {
    if (currentQuestion == null) return;

    final selectedIndex = _selectedAnswers[_currentQuestionIndex];
    final isCorrect = currentQuestion!.isCorrectAnswer(selectedIndex);

    final questionResult = QuestionResult(
      questionId: currentQuestion!.id,
      question: currentQuestion!.question,
      options: currentQuestion!.options,
      correctAnswerIndex: currentQuestion!.correctAnswerIndex,
      selectedAnswerIndex: selectedIndex,
      isCorrect: isCorrect,
      explanation: currentQuestion!.explanation,
      timeSpent: timeSpent,
    );

    // Update or add question result
    if (_currentQuestionIndex < _questionResults.length) {
      _questionResults[_currentQuestionIndex] = questionResult;
    } else {
      _questionResults.add(questionResult);
    }
  }

  // Restart the current quiz
  Future<void> restartQuiz() async {
    if (_selectedCategory == null) return;
    
    await startQuiz(_selectedCategory!, questionCount: _questions.length);
  }

  // Go back to home
  void goHome() {
    _resetState();
    _setState(QuizState.ready);
  }

  // Reset all state
  void _resetState() {
    _selectedCategory = null;
    _questions = [];
    _currentQuestionIndex = 0;
    _selectedAnswers = [];
    _questionResults = [];
    _quizStartTime = null;
    _questionStartTime = null;
    _totalTimeTaken = Duration.zero;
    _quizResult = null;
    _errorMessage = null;
  }

  // Set state and notify listeners
  void _setState(QuizState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  // Set error state
  void _setError(String message) {
    _state = QuizState.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Get user progress
  Future<UserProgress?> getUserProgress() async {
    try {
      return await _repository.loadUserProgress();
    } catch (e) {
      print('Error loading user progress: $e');
      return null;
    }
  }

  // Get recent results
  Future<List<QuizResult>> getRecentResults({int limit = 10}) async {
    try {
      return await _repository.getRecentResults(limit: limit);
    } catch (e) {
      print('Error loading recent results: $e');
      return [];
    }
  }

  // Clear all progress
  Future<void> clearProgress() async {
    try {
      await _repository.clearProgress();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear progress: $e');
    }
  }

  // Get app settings
  Future<Map<String, dynamic>> getSettings() async {
    try {
      return await _repository.getSettings();
    } catch (e) {
      print('Error loading settings: $e');
      return {};
    }
  }

  // Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      await _repository.saveSettings(settings);
    } catch (e) {
      _setError('Failed to save settings: $e');
    }
  }

}

