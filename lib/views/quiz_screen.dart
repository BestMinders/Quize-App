import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quiz_viewmodel.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_indicator.dart';
import '../widgets/result_summary.dart';
import '../widgets/app_icon.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/screen_utils.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startQuiz();
    });
  }

  void _startQuiz() {
    final viewModel = Provider.of<QuizViewModel>(context, listen: false);
    viewModel.startQuiz(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final theme = Theme.of(context);
    final viewModel = Provider.of<QuizViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppIconCompact(size: ScreenUtils.getCompactLogoSize() * 0.75),
            SizedBox(width: ScreenUtils.getWidth(2)),
            Expanded(
              child: Text(
                widget.category,
                style: TextStyle(fontSize: ScreenUtils.getFontSize(18)),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context, viewModel),
        ),
        actions: [
          if (viewModel.state == QuizState.inProgress)
            TextButton(
              onPressed: () => _showExitDialog(context, viewModel),
              child: const Text('Exit'),
            ),
        ],
      ),
      body: _buildBody(context, theme, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, QuizViewModel viewModel) {
    switch (viewModel.state) {
      case QuizState.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppTheme.paddingM),
              Text('Loading quiz...'),
            ],
          ),
        );

      case QuizState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppTheme.paddingM),
              Text(
                'Error loading quiz',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.paddingS),
              Text(
                viewModel.errorMessage ?? 'Unknown error occurred',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.paddingL),
              ElevatedButton(
                onPressed: _startQuiz,
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case QuizState.inProgress:
        return _buildQuizContent(context, theme, viewModel);

      case QuizState.completed:
        return _buildCompletedView(context, theme, viewModel);

      default:
        return const Center(child: Text('Unknown state'));
    }
  }

  Widget _buildQuizContent(BuildContext context, ThemeData theme, QuizViewModel viewModel) {
    final currentQuestion = viewModel.currentQuestion;
    if (currentQuestion == null) {
      return const Center(child: Text('No question available'));
    }

    final selectedAnswer = viewModel.selectedAnswers[viewModel.currentQuestionIndex];

    return Column(
      children: [
        // Progress indicator
        QuizProgressIndicator(
          currentQuestion: viewModel.currentQuestionIndex + 1,
          totalQuestions: viewModel.totalQuestions,
        ),
        
        // Question card
        Expanded(
          child: SingleChildScrollView(
            child: QuestionCard(
              question: currentQuestion,
              questionNumber: viewModel.currentQuestionIndex + 1,
              totalQuestions: viewModel.totalQuestions,
              selectedAnswer: selectedAnswer >= 0 ? selectedAnswer : null,
              onAnswerSelected: (index) {
                viewModel.selectAnswer(index);
              },
            ),
          ),
        ),
        
        // Navigation buttons
        _buildNavigationButtons(context, theme, viewModel),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context, ThemeData theme, QuizViewModel viewModel) {
    final selectedAnswer = viewModel.selectedAnswers[viewModel.currentQuestionIndex];
    final hasSelectedAnswer = selectedAnswer >= 0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          if (!viewModel.isFirstQuestion)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: viewModel.previousQuestion,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
            ),
          
          if (!viewModel.isFirstQuestion)
            const SizedBox(width: AppTheme.paddingM),
          
          // Next/Complete button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: hasSelectedAnswer
                  ? (viewModel.isLastQuestion
                      ? () => _showCompleteDialog(context, viewModel)
                      : viewModel.nextQuestion)
                  : null,
              icon: Icon(
                viewModel.isLastQuestion ? Icons.check : Icons.arrow_forward,
              ),
              label: Text(
                viewModel.isLastQuestion ? 'Complete Quiz' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedView(BuildContext context, ThemeData theme, QuizViewModel viewModel) {
    final result = viewModel.quizResult;
    if (result == null) {
      return const Center(child: Text('No result available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: AppTheme.paddingL),
          
          // Result summary
          ResultSummary(
            result: result,
            onRetry: () {
              viewModel.restartQuiz();
            },
            onHome: () {
              viewModel.goHome();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          
          const SizedBox(height: AppTheme.paddingL),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context, QuizViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.goHome();
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, QuizViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Quiz'),
        content: const Text(
          'Are you ready to complete the quiz and see your results?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Review'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.completeQuiz();
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}

