import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';

class QuizProgressIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Duration? timeRemaining;
  final bool showTime;

  const QuizProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.timeRemaining,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalQuestions > 0 ? currentQuestion / totalQuestions : 0.0;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingM,
        vertical: AppTheme.paddingS,
      ),
      child: Column(
        children: [
          // Progress bar
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                  minHeight: 8,
                ).animate().scaleX(
                  duration: 300.ms,
                  curve: Curves.easeOutCubic,
                ),
              ),
              const SizedBox(width: AppTheme.paddingM),
              Text(
                '$currentQuestion/$totalQuestions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          
          // Time remaining (if enabled)
          if (showTime && timeRemaining != null) ...[
            const SizedBox(height: AppTheme.paddingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: AppTheme.paddingXS),
                Text(
                  _formatDuration(timeRemaining!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${seconds}s';
    }
  }
}

