import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/question.dart';
import '../core/theme/app_theme.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final int? selectedAnswer;
  final Function(int) onAnswerSelected;
  final bool showResult;
  final bool isCorrect;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    this.selectedAnswer,
    required this.onAnswerSelected,
    this.showResult = false,
    this.isCorrect = false,
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
            // Question header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingM,
                    vertical: AppTheme.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(
                    'Question $questionNumber of $totalQuestions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (showResult)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingM,
                      vertical: AppTheme.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: AppTheme.paddingXS),
                        Text(
                          isCorrect ? 'Correct' : 'Wrong',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: AppTheme.paddingL),
            
            // Question text
            Text(
              question.question,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: AppTheme.paddingXL),
            
            // Answer options
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedAnswer == index;
              final isCorrectAnswer = index == question.correctAnswerIndex;
              
              Color? backgroundColor;
              Color? textColor;
              Color? borderColor;
              
              if (showResult) {
                if (isCorrectAnswer) {
                  backgroundColor = AppTheme.successColor.withOpacity(0.1);
                  textColor = AppTheme.successColor;
                  borderColor = AppTheme.successColor;
                } else if (isSelected && !isCorrectAnswer) {
                  backgroundColor = AppTheme.errorColor.withOpacity(0.1);
                  textColor = AppTheme.errorColor;
                  borderColor = AppTheme.errorColor;
                } else {
                  backgroundColor = theme.colorScheme.surface;
                  textColor = theme.colorScheme.onSurface;
                  borderColor = theme.colorScheme.outline;
                }
              } else {
                backgroundColor = isSelected 
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surface;
                textColor = isSelected 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface;
                borderColor = isSelected 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline;
              }
              
              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.paddingM),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: showResult ? null : () => onAnswerSelected(index),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.paddingM),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(
                          color: borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Option letter
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: borderColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: AppTheme.paddingM),
                          
                          // Option text
                          Expanded(
                            child: Text(
                              option,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: textColor,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          
                          // Result icon
                          if (showResult && isCorrectAnswer)
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.successColor,
                              size: 24,
                            )
                          else if (showResult && isSelected && !isCorrectAnswer)
                            Icon(
                              Icons.cancel,
                              color: AppTheme.errorColor,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: (index * 100).ms);
            }),
            
            // Explanation
            if (showResult && question.explanation != null) ...[
              const SizedBox(height: AppTheme.paddingL),
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingM),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.paddingS),
                        Text(
                          'Explanation',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.paddingS),
                    Text(
                      question.explanation!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().slideX(
      begin: 0.3,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

