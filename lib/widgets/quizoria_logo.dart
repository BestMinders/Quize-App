import 'package:flutter/material.dart';
import '../core/utils/screen_utils.dart';

class QuizoriaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? questionMarkColor;
  final Color? lightningColor;

  const QuizoriaLogo({
    super.key,
    this.size = 120.0,
    this.showText = true,
    this.backgroundColor,
    this.textColor,
    this.questionMarkColor,
    this.lightningColor,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Use provided colors or default based on theme
    final bgColor = backgroundColor ?? (isDark ? const Color(0xFF6A1B9A) : const Color(0xFF7B1FA2));
    final txtColor = textColor ?? Colors.white;
    final qmColor = questionMarkColor ?? Colors.white;
    final ltColor = lightningColor ?? const Color(0xFFFFD700);
    
    // Responsive sizing
    final responsiveSize = size > 0 ? size : ScreenUtils.getLogoSize();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon
        Container(
          width: responsiveSize,
          height: responsiveSize,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ScreenUtils.getRadius(responsiveSize * 0.25)),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: ScreenUtils.getRadius(20),
                offset: Offset(0, ScreenUtils.getRadius(10)),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Question Mark
              Positioned(
                left: responsiveSize * 0.15,
                top: responsiveSize * 0.1,
                child: Text(
                  '?',
                  style: TextStyle(
                    color: qmColor,
                    fontSize: ScreenUtils.getFontSize(responsiveSize * 0.4),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              // Lightning Bolt
              Positioned(
                right: responsiveSize * 0.1,
                top: responsiveSize * 0.15,
                child: CustomPaint(
                  size: Size(responsiveSize * 0.35, responsiveSize * 0.4),
                  painter: LightningPainter(ltColor),
                ),
              ),
            ],
          ),
        ),
        
        // App Name
        if (showText) ...[
          SizedBox(height: responsiveSize * 0.15),
          Text(
            'Quizoria',
            style: TextStyle(
              color: txtColor,
              fontSize: ScreenUtils.getFontSize(responsiveSize * 0.25),
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

class LightningPainter extends CustomPainter {
  final Color color;

  LightningPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create lightning bolt shape
    final width = size.width;
    final height = size.height;
    
    // Top part of lightning
    path.moveTo(width * 0.3, 0);
    path.lineTo(width * 0.7, height * 0.3);
    path.lineTo(width * 0.5, height * 0.3);
    path.lineTo(width * 0.8, height * 0.6);
    path.lineTo(width * 0.2, height * 0.6);
    path.lineTo(width * 0.4, height * 0.6);
    path.lineTo(width * 0.1, height);
    path.lineTo(width * 0.5, height * 0.7);
    path.lineTo(width * 0.3, height * 0.7);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Compact version for app bars
class QuizoriaLogoCompact extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? questionMarkColor;
  final Color? lightningColor;

  const QuizoriaLogoCompact({
    super.key,
    this.size = 40.0,
    this.backgroundColor,
    this.questionMarkColor,
    this.lightningColor,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = backgroundColor ?? (isDark ? const Color(0xFF6A1B9A) : const Color(0xFF7B1FA2));
    final qmColor = questionMarkColor ?? Colors.white;
    final ltColor = lightningColor ?? const Color(0xFFFFD700);
    
    // Responsive sizing
    final responsiveSize = size > 0 ? size : ScreenUtils.getCompactLogoSize();

    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ScreenUtils.getRadius(responsiveSize * 0.25)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Question Mark
          Positioned(
            left: responsiveSize * 0.15,
            top: responsiveSize * 0.1,
            child: Text(
              '?',
              style: TextStyle(
                color: qmColor,
                fontSize: ScreenUtils.getFontSize(responsiveSize * 0.4),
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          // Lightning Bolt
          Positioned(
            right: responsiveSize * 0.1,
            top: responsiveSize * 0.15,
            child: CustomPaint(
              size: Size(responsiveSize * 0.35, responsiveSize * 0.4),
              painter: LightningPainter(ltColor),
            ),
          ),
        ],
      ),
    );
  }
}
