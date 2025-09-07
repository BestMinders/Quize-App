import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/constants.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'views/splash_screen.dart';
import 'views/home_screen.dart';
import 'views/quiz_screen.dart';
import 'views/result_screen.dart';
import 'views/settings_screen.dart';
import 'views/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  await SharedPreferences.getInstance();
  
  runApp(const QuizoriaApp());
}

class QuizoriaApp extends StatefulWidget {
  const QuizoriaApp({super.key});

  @override
  State<QuizoriaApp> createState() => _QuizoriaAppState();
}

class _QuizoriaAppState extends State<QuizoriaApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(AppConstants.themeKey) ?? 'system';
    
    setState(() {
      switch (themeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      _isLoading = false;
    });
  }

  void _changeTheme(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    await prefs.setString(AppConstants.themeKey, themeString);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading Quizoria...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
      ],
      child: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeMode,
            initialRoute: '/home',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  );
                case '/home':
                  return MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  );
                case '/quiz':
                  final args = settings.arguments as Map<String, dynamic>?;
                  final category = args?['category'] as String? ?? 'General Knowledge';
                  return MaterialPageRoute(
                    builder: (context) => QuizScreen(category: category),
                  );
                case '/result':
                  return MaterialPageRoute(
                    builder: (context) => const ResultScreen(),
                  );
                case '/settings':
                  return MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onThemeChanged: _changeTheme,
                    ),
                  );
                case '/about':
                  return MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  );
              }
            },
          );
        },
      ),
    );
  }
}