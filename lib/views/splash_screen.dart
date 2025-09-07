import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/utils/screen_utils.dart';
import '../widgets/app_icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _scaleController.forward();
    
    // Navigate to home screen after animations complete
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ]
                : [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                    const Color(0xFF6B73FF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: ScreenUtils.getHeight(8)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              // Main Logo with Animation
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: AppIcon(
                            size: ScreenUtils.getLogoSize(),
                            showText: true,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
              SizedBox(height: ScreenUtils.getHeight(8)),
              
              // App Description with Animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.8,
                    child: Column(
                      children: [
                        Text(
                          'Test Your Knowledge',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            fontSize: ScreenUtils.getFontSize(24),
                          ),
                        ),
                        SizedBox(height: ScreenUtils.getHeight(1.5)),
                        Text(
                          'Offline Quiz & Trivia Game',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 0.5,
                            fontSize: ScreenUtils.getFontSize(16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              SizedBox(height: ScreenUtils.getHeight(10)),
              
              // Loading Indicator with Animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        SizedBox(
                          width: ScreenUtils.getWidth(10),
                          height: ScreenUtils.getWidth(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtils.getHeight(2)),
                        Text(
                          'Loading...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                            fontSize: ScreenUtils.getFontSize(14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const Spacer(),
              
              // Version Info
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.6,
                    child:                       Text(
                        'Version ${AppConstants.appVersion}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 0.5,
                          fontSize: ScreenUtils.getFontSize(12),
                        ),
                      ),
                  );
                },
              ),
              
              SizedBox(height: ScreenUtils.getHeight(2.5)),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
