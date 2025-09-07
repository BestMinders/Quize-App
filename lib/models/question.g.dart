// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as String,
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      category: json['category'] as String,
      explanation: json['explanation'] as String?,
      difficulty: (json['difficulty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'category': instance.category,
      'explanation': instance.explanation,
      'difficulty': instance.difficulty,
    };

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeLimit: (json['timeLimit'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'description': instance.description,
      'questions': instance.questions,
      'timeLimit': instance.timeLimit,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => QuizResult(
      quizId: json['quizId'] as String,
      category: json['category'] as String,
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      wrongAnswers: (json['wrongAnswers'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      timeTaken: Duration(microseconds: (json['timeTaken'] as num).toInt()),
      completedAt: DateTime.parse(json['completedAt'] as String),
      questionResults: (json['questionResults'] as List<dynamic>)
          .map((e) => QuestionResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizResultToJson(QuizResult instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'category': instance.category,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'wrongAnswers': instance.wrongAnswers,
      'percentage': instance.percentage,
      'timeTaken': instance.timeTaken.inMicroseconds,
      'completedAt': instance.completedAt.toIso8601String(),
      'questionResults': instance.questionResults,
    };

QuestionResult _$QuestionResultFromJson(Map<String, dynamic> json) =>
    QuestionResult(
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      selectedAnswerIndex: (json['selectedAnswerIndex'] as num).toInt(),
      isCorrect: json['isCorrect'] as bool,
      explanation: json['explanation'] as String?,
      timeSpent: Duration(microseconds: (json['timeSpent'] as num).toInt()),
    );

Map<String, dynamic> _$QuestionResultToJson(QuestionResult instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'question': instance.question,
      'options': instance.options,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'selectedAnswerIndex': instance.selectedAnswerIndex,
      'isCorrect': instance.isCorrect,
      'explanation': instance.explanation,
      'timeSpent': instance.timeSpent.inMicroseconds,
    };

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
      userId: json['userId'] as String,
      categoryScores: Map<String, int>.from(json['categoryScores'] as Map),
      recentResults: (json['recentResults'] as List<dynamic>)
          .map((e) => QuizResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalQuizzesTaken: (json['totalQuizzesTaken'] as num).toInt(),
      totalQuestionsAnswered: (json['totalQuestionsAnswered'] as num).toInt(),
      totalCorrectAnswers: (json['totalCorrectAnswers'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'categoryScores': instance.categoryScores,
      'recentResults': instance.recentResults,
      'totalQuizzesTaken': instance.totalQuizzesTaken,
      'totalQuestionsAnswered': instance.totalQuestionsAnswered,
      'totalCorrectAnswers': instance.totalCorrectAnswers,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
