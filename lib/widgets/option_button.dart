import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';
import '../core/constants.dart';

class OptionButton extends StatelessWidget {
  final String option;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool showResult;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.option,
    required this.index,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.showResult = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    Color iconColor;
    IconData? icon;
    
    if (showResult) {
      if (isCorrect) {
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        textColor = AppTheme.successColor;
        borderColor = AppTheme.successColor;
        iconColor = AppTheme.successColor;
        icon = Icons.check_circle;
      } else if (isWrong) {
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
        textColor = AppTheme.errorColor;
        borderColor = AppTheme.errorColor;
        iconColor = AppTheme.errorColor;
        icon = Icons.cancel;
      } else {
        backgroundColor = theme.colorScheme.surface;
        textColor = theme.colorScheme.onSurface.withOpacity(0.6);
        borderColor = theme.colorScheme.outline.withOpacity(0.3);
        iconColor = theme.colorScheme.onSurface.withOpacity(0.3);
        icon = null;
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
      iconColor = theme.colorScheme.primary;
      icon = null;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingM),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: showResult ? null : onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          child: AnimatedContainer(
            duration: AppConstants.shortAnimation,
            padding: const EdgeInsets.all(AppTheme.paddingM),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: borderColor,
                width: 1.5,
              ),
              boxShadow: isSelected && !showResult
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Option letter
                AnimatedContainer(
                  duration: AppConstants.shortAnimation,
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
                if (icon != null)
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ).animate().scale(
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 300.ms,
      delay: (index * 100).ms,
    ).slideX(
      begin: 0.2,
      duration: 300.ms,
      delay: (index * 100).ms,
    );
  }
}

