import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;
  final String? explanation;
  final int? difficulty; // 1-5 scale

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    this.explanation,
    this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  String get correctAnswer => options[correctAnswerIndex];

  bool isCorrectAnswer(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Question(id: $id, question: $question, category: $category)';
  }
}

@JsonSerializable()
class Quiz {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<Question> questions;
  final int timeLimit; // in seconds, 0 means no limit
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Quiz({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.questions,
    this.timeLimit = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);

  int get questionCount => questions.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quiz && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Quiz(id: $id, title: $title, category: $category, questionCount: $questionCount)';
  }
}

@JsonSerializable()
class QuizResult {
  final String quizId;
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;
  final Duration timeTaken;
  final DateTime completedAt;
  final List<QuestionResult> questionResults;

  const QuizResult({
    required this.quizId,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
    required this.timeTaken,
    required this.completedAt,
    required this.questionResults,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) => _$QuizResultFromJson(json);
  Map<String, dynamic> toJson() => _$QuizResultToJson(this);

  String get performance {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 70) return 'Good';
    if (percentage >= 50) return 'Average';
    return 'Needs Improvement';
  }

  @override
  String toString() {
    return 'QuizResult(quizId: $quizId, percentage: $percentage%, performance: $performance)';
  }
}

@JsonSerializable()
class QuestionResult {
  final String questionId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int selectedAnswerIndex;
  final bool isCorrect;
  final String? explanation;
  final Duration timeSpent;

  const QuestionResult({
    required this.questionId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    this.explanation,
    required this.timeSpent,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) => _$QuestionResultFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionResultToJson(this);

  String get selectedAnswer => options[selectedAnswerIndex];
  String get correctAnswer => options[correctAnswerIndex];

  @override
  String toString() {
    return 'QuestionResult(questionId: $questionId, isCorrect: $isCorrect)';
  }
}

@JsonSerializable()
class UserProgress {
  final String userId;
  final Map<String, int> categoryScores; // category -> best score
  final List<QuizResult> recentResults;
  final int totalQuizzesTaken;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final DateTime lastUpdated;

  const UserProgress({
    required this.userId,
    required this.categoryScores,
    required this.recentResults,
    required this.totalQuizzesTaken,
    required this.totalQuestionsAnswered,
    required this.totalCorrectAnswers,
    required this.lastUpdated,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) => _$UserProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  double get overallAccuracy {
    if (totalQuestionsAnswered == 0) return 0.0;
    return (totalCorrectAnswers / totalQuestionsAnswered) * 100;
  }

  int get bestCategoryScore {
    if (categoryScores.isEmpty) return 0;
    return categoryScores.values.reduce((a, b) => a > b ? a : b);
  }

  String get bestCategory {
    if (categoryScores.isEmpty) return 'None';
    return categoryScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  @override
  String toString() {
    return 'UserProgress(userId: $userId, totalQuizzes: $totalQuizzesTaken, accuracy: ${overallAccuracy.toStringAsFixed(1)}%)';
  }
}


