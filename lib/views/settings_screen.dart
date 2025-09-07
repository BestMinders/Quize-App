import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quiz_viewmodel.dart';
import '../core/theme/app_theme.dart';
import '../core/constants.dart';
import '../core/utils/screen_utils.dart';
import '../widgets/app_icon.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  
  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final viewModel = Provider.of<QuizViewModel>(context, listen: false);
    final settings = await viewModel.getSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final viewModel = Provider.of<QuizViewModel>(context, listen: false);
    await viewModel.saveSettings(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
              'Settings',
              style: TextStyle(fontSize: ScreenUtils.getFontSize(20)),
            ),
          ],
        ),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _saveSettings,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: ScreenUtils.getPadding(all: 16),
              children: [
                // App Info Section
                _buildSection(
                  theme,
                  'App Information',
                  [
                    _buildInfoTile(
                      theme,
                      'App Name',
                      AppConstants.appName,
                      Icons.info,
                    ),
                    _buildInfoTile(
                      theme,
                      'Version',
                      AppConstants.appVersion,
                      Icons.tag,
                    ),
                  ],
                ),
                
                SizedBox(height: ScreenUtils.getHeight(3)),
                
                // Theme Settings
                _buildSection(
                  theme,
                  'Appearance',
                  [
                    _buildSwitchTile(
                      theme,
                      'Dark Mode',
                      'Use dark theme for the app',
                      Icons.dark_mode,
                      _settings['theme'] == 'dark',
                      (value) {
                        setState(() {
                          _settings['theme'] = value ? 'dark' : 'light';
                        });
                        widget.onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: ScreenUtils.getHeight(3)),
                
                // Quiz Settings
                _buildSection(
                  theme,
                  'Quiz Settings',
                  [
                    _buildSwitchTile(
                      theme,
                      'Show Explanations',
                      'Show explanations after each question',
                      Icons.lightbulb_outline,
                      _settings['showExplanations'] ?? true,
                      (value) {
                        setState(() {
                          _settings['showExplanations'] = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      theme,
                      'Auto Next Question',
                      'Automatically move to next question after selection',
                      Icons.skip_next,
                      _settings['autoNextQuestion'] ?? false,
                      (value) {
                        setState(() {
                          _settings['autoNextQuestion'] = value;
                        });
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: ScreenUtils.getHeight(3)),
                
                // Data Management
                _buildSection(
                  theme,
                  'Data Management',
                  [
                    _buildActionTile(
                      theme,
                      'Clear Progress',
                      'Reset all quiz progress and statistics',
                      Icons.delete_forever,
                      Colors.red,
                      () => _showClearProgressDialog(context),
                    ),
                  ],
                ),
                
                SizedBox(height: ScreenUtils.getHeight(3)),
                
                // About Section
                _buildSection(
                  theme,
                  'About',
                  [
                    _buildActionTile(
                      theme,
                      'About Quizoria',
                      'Learn more about this app',
                      Icons.info_outline,
                      theme.colorScheme.primary,
                      () => Navigator.pushNamed(context, '/about'),
                    ),
                  ],
                ),
              ],
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

  Widget _buildInfoTile(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingS,
      ),
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingS,
      ),
    );
  }

  Widget _buildActionTile(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingS,
      ),
    );
  }

  void _showClearProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Progress'),
        content: const Text(
          'Are you sure you want to clear all your quiz progress? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              final viewModel = Provider.of<QuizViewModel>(context, listen: false);
              await viewModel.clearProgress();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Progress cleared successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
