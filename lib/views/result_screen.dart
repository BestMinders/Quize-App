import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quiz_viewmodel.dart';
import '../widgets/result_summary.dart';
import '../widgets/app_icon.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/screen_utils.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

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
            Text(
              'Quiz Results',
              style: TextStyle(fontSize: ScreenUtils.getFontSize(18)),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              viewModel.goHome();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: viewModel.quizResult != null
          ? SingleChildScrollView(
              padding: ScreenUtils.getPadding(all: 16),
              child: ResultSummary(
                result: viewModel.quizResult!,
                onRetry: () {
                  viewModel.restartQuiz();
                  Navigator.pushReplacementNamed(
                    context,
                    '/quiz',
                    arguments: {'category': viewModel.selectedCategory},
                  );
                },
                onHome: () {
                  viewModel.goHome();
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            )
          : Center(
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
                    'No results available',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.paddingM),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
    );
  }
}




