import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants.dart';
import '../core/utils/screen_utils.dart';
import '../widgets/app_icon.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppIconCompact(size: ScreenUtils.getCompactLogoSize() * 0.875),
            SizedBox(width: ScreenUtils.getWidth(3)),
            Text(
              'About',
              style: TextStyle(fontSize: ScreenUtils.getFontSize(20)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: ScreenUtils.getPadding(all: 16),
        child: Column(
          children: [
            // App Icon and Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingXL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.secondary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              child: Column(
                children: [
                  AppIcon(
                    size: ScreenUtils.getLogoSize() * 0.67,
                    showText: false,
                  ),
                  const SizedBox(height: AppTheme.paddingL),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingS),
                  Text(
                    AppConstants.appDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.paddingM),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingM,
                      vertical: AppTheme.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      'Version ${AppConstants.appVersion}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: ScreenUtils.getHeight(3)),
            
            // Features
            _buildSection(
              theme,
              'Features',
              [
                _buildFeatureItem(
                  theme,
                  Icons.offline_bolt,
                  'Offline Mode',
                  'All quizzes work without internet connection',
                ),
                _buildFeatureItem(
                  theme,
                  Icons.category,
                  'Multiple Categories',
                  'Choose from various quiz categories',
                ),
                _buildFeatureItem(
                  theme,
                  Icons.analytics,
                  'Progress Tracking',
                  'Track your performance and improvement',
                ),
                _buildFeatureItem(
                  theme,
                  Icons.palette,
                  'Dark/Light Theme',
                  'Switch between themes for your preference',
                ),
                _buildFeatureItem(
                  theme,
                  Icons.speed,
                  'Fast & Smooth',
                  'Optimized for the best user experience',
                ),
              ],
            ),
            
            SizedBox(height: ScreenUtils.getHeight(3)),
            
            // Disclaimer
            _buildSection(
              theme,
              'Disclaimer',
              [
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingM),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.paddingS),
                          Text(
                            'Important Notice',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.paddingS),
                      Text(
                        'This app is for educational and entertainment purposes only. '
                        'While we strive to provide accurate information, quiz content '
                        'should not be considered as the sole source of knowledge. '
                        'Always verify important information from reliable sources.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: ScreenUtils.getHeight(3)),
            
            // Contact/Support
            _buildSection(
              theme,
              'Support',
              [
                _buildActionItem(
                  theme,
                  Icons.bug_report,
                  'Report a Bug',
                  'Help us improve by reporting issues',
                  () => _showComingSoon(context),
                ),
                _buildActionItem(
                  theme,
                  Icons.feedback,
                  'Send Feedback',
                  'Share your thoughts and suggestions',
                  () => _showComingSoon(context),
                ),
              ],
            ),
            
            SizedBox(height: ScreenUtils.getHeight(3)),
            
            // Copyright
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingM),
              child: Text(
                '© 2024 Quizoria. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppTheme.paddingM,
            bottom: AppTheme.paddingS,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.paddingS),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(description),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingS,
      ),
    );
  }

  Widget _buildActionItem(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingS,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

