import 'package:flutter/material.dart';
import '../core/utils/screen_utils.dart';

class QuizoriaImageLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final String? imagePath;

  const QuizoriaImageLogo({
    super.key,
    this.size = 120.0,
    this.showText = true,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    
    // Use provided size or responsive size
    final responsiveSize = size > 0 ? size : ScreenUtils.getLogoSize();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Image
        Container(
          width: responsiveSize,
          height: responsiveSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtils.getRadius(responsiveSize * 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: ScreenUtils.getRadius(20),
                offset: Offset(0, ScreenUtils.getRadius(10)),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtils.getRadius(responsiveSize * 0.25)),
            child: _buildLogoImage(),
          ),
        ),
        
        // App Name (if showText is true)
        if (showText) ...[
          SizedBox(height: responsiveSize * 0.15),
          Text(
            'Quizoria',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
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

  Widget _buildLogoImage() {
    // Try to load the image, fallback to programmatic logo if not found
    try {
      return Image.asset(
        imagePath ?? 'assets/images/quizoria_logo.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to programmatic logo if image not found
          return _buildFallbackLogo();
        },
      );
    } catch (e) {
      // Fallback to programmatic logo if image not found
      return _buildFallbackLogo();
    }
  }

  Widget _buildFallbackLogo() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7B1FA2),
            const Color(0xFF6A1B9A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Question Mark
          Positioned(
            left: size * 0.15,
            top: size * 0.1,
            child: Text(
              '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtils.getFontSize(size * 0.4),
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          // Lightning Bolt
          Positioned(
            right: size * 0.1,
            top: size * 0.15,
            child: CustomPaint(
              size: Size(size * 0.35, size * 0.4),
              painter: LightningPainter(const Color(0xFFFFD700)),
            ),
          ),
          // App Name
          Positioned(
            bottom: size * 0.15,
            child: Text(
              'Quizoria',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtils.getFontSize(size * 0.15),
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Compact version for app bars
class QuizoriaImageLogoCompact extends StatelessWidget {
  final double size;
  final String? imagePath;

  const QuizoriaImageLogoCompact({
    super.key,
    this.size = 40.0,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    
    // Use provided size or responsive size
    final responsiveSize = size > 0 ? size : ScreenUtils.getCompactLogoSize();
    
    return Container(
      width: responsiveSize,
      height: responsiveSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtils.getRadius(responsiveSize * 0.25)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtils.getRadius(responsiveSize * 0.25)),
        child: _buildLogoImage(),
      ),
    );
  }

  Widget _buildLogoImage() {
    // Try to load the image, fallback to programmatic logo if not found
    try {
      return Image.asset(
        imagePath ?? 'assets/images/quizoria_logo.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to programmatic logo if image not found
          return _buildFallbackLogo();
        },
      );
    } catch (e) {
      // Fallback to programmatic logo if image not found
      return _buildFallbackLogo();
    }
  }

  Widget _buildFallbackLogo() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7B1FA2),
            const Color(0xFF6A1B9A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Question Mark
          Positioned(
            left: size * 0.15,
            top: size * 0.1,
            child: Text(
              '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtils.getFontSize(size * 0.4),
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          // Lightning Bolt
          Positioned(
            right: size * 0.1,
            top: size * 0.15,
            child: CustomPaint(
              size: Size(size * 0.35, size * 0.4),
              painter: LightningPainter(const Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
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

