import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/question.dart';
import '../core/theme/app_theme.dart';

class ResultSummary extends StatelessWidget {
  final QuizResult result;
  final VoidCallback? onRetry;
  final VoidCallback? onHome;

  const ResultSummary({
    super.key,
    required this.result,
    this.onRetry,
    this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(AppTheme.paddingM),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingM),
                  decoration: BoxDecoration(
                    color: _getPerformanceColor(result.percentage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  ),
                  child: Icon(
                    _getPerformanceIcon(result.percentage),
                    color: _getPerformanceColor(result.percentage),
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppTheme.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiz Completed!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        result.category,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.paddingXL),
            
            // Score display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getPerformanceColor(result.percentage).withOpacity(0.1),
                    _getPerformanceColor(result.percentage).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                border: Border.all(
                  color: _getPerformanceColor(result.percentage).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${result.percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: _getPerformanceColor(result.percentage),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    result.performance,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: _getPerformanceColor(result.percentage),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate().scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
            
            const SizedBox(height: AppTheme.paddingXL),
            
            // Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Correct',
                    result.correctAnswers.toString(),
                    AppTheme.successColor,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: AppTheme.paddingM),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Wrong',
                    result.wrongAnswers.toString(),
                    AppTheme.errorColor,
                    Icons.cancel,
                  ),
                ),
                const SizedBox(width: AppTheme.paddingM),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total',
                    result.totalQuestions.toString(),
                    theme.colorScheme.primary,
                    Icons.quiz,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.paddingL),
            
            // Time taken
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingM),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.paddingS),
                  Text(
                    'Time Taken: ${_formatDuration(result.timeTaken)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.paddingXL),
            
            // Action buttons
            Row(
              children: [
                if (onRetry != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry Quiz'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.paddingM,
                        ),
                      ),
                    ),
                  ),
                if (onRetry != null && onHome != null)
                  const SizedBox(width: AppTheme.paddingM),
                if (onHome != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onHome,
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.paddingM,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().slideY(
      begin: 0.3,
      duration: 500.ms,
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppTheme.paddingS),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: 200.ms,
    );
  }

  Color _getPerformanceColor(double percentage) {
    if (percentage >= 90) return AppTheme.successColor;
    if (percentage >= 70) return AppTheme.warningColor;
    if (percentage >= 50) return Colors.orange;
    return AppTheme.errorColor;
  }

  IconData _getPerformanceIcon(double percentage) {
    if (percentage >= 90) return Icons.emoji_events;
    if (percentage >= 70) return Icons.thumb_up;
    if (percentage >= 50) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}


