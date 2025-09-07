import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../viewmodels/quiz_viewmodel.dart';
import '../core/theme/app_theme.dart';
import '../core/constants.dart';
import '../core/utils/screen_utils.dart';
import '../widgets/app_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final viewModel = Provider.of<QuizViewModel>(context, listen: false);
    final categories = await viewModel.loadCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final theme = Theme.of(context);
    final viewModel = Provider.of<QuizViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            AppIconCompact(size: ScreenUtils.getCompactLogoSize()),
            SizedBox(width: ScreenUtils.getWidth(3)),
            Text(
              AppConstants.appName,
              style: TextStyle(fontSize: ScreenUtils.getFontSize(20)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategories,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: ScreenUtils.getPadding(all: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    _buildWelcomeSection(theme),
                    
                    SizedBox(height: ScreenUtils.getHeight(3)),
                    
                    // Categories section
                    _buildCategoriesSection(theme, viewModel),
                    
                    SizedBox(height: ScreenUtils.getHeight(3)),
                    
                    // Quick stats section
                    _buildQuickStatsSection(theme, viewModel),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: ScreenUtils.getPadding(all: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ScreenUtils.getRadius(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: ScreenUtils.getPadding(all: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(ScreenUtils.getRadius(16)),
                ),
                child: Icon(
                  Icons.quiz,
                  color: Colors.white,
                  size: ScreenUtils.getIconSize(32),
                ),
              ),
              SizedBox(width: ScreenUtils.getWidth(4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Quizoria!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: ScreenUtils.getFontSize(20),
                      ),
                    ),
                    Text(
                      'Test your knowledge with our offline quizzes',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: ScreenUtils.getFontSize(16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, duration: 600.ms);
  }

  Widget _buildCategoriesSection(ThemeData theme, QuizViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a Category',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtils.getFontSize(18),
          ),
        ),
        SizedBox(height: ScreenUtils.getHeight(2)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ScreenUtils.getGridColumns(),
            childAspectRatio: ScreenUtils.getCardAspectRatio(),
            crossAxisSpacing: ScreenUtils.getWidth(4),
            mainAxisSpacing: ScreenUtils.getHeight(2),
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildCategoryCard(theme, category, viewModel, index);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    ThemeData theme,
    String category,
    QuizViewModel viewModel,
    int index,
  ) {
    final categoryIcon = _getCategoryIcon(category);
    final categoryColor = _getCategoryColor(category);

    return Card(
      elevation: AppTheme.elevationS,
      child: InkWell(
        onTap: () => _startQuiz(context, category, viewModel),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Container(
          padding: ScreenUtils.getPadding(all: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtils.getRadius(12)),
            gradient: LinearGradient(
              colors: [
                categoryColor.withOpacity(0.1),
                categoryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: ScreenUtils.getPadding(all: 16),
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(ScreenUtils.getRadius(16)),
                ),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: ScreenUtils.getIconSize(32),
                ),
              ),
              SizedBox(height: ScreenUtils.getHeight(2)),
              Text(
                category,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtils.getFontSize(14),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: (index * 100).ms,
    ).scale(
      begin: const Offset(0.8, 0.8),
      duration: 400.ms,
      delay: (index * 100).ms,
    );
  }

  Widget _buildQuickStatsSection(ThemeData theme, QuizViewModel viewModel) {
    return FutureBuilder(
      future: viewModel.getUserProgress(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final progress = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtils.getFontSize(18),
                ),
              ),
              SizedBox(height: ScreenUtils.getHeight(2)),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      theme,
                      'Quizzes Taken',
                      progress.totalQuizzesTaken.toString(),
                      Icons.quiz,
                      theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: ScreenUtils.getWidth(4)),
                  Expanded(
                    child: _buildStatCard(
                      theme,
                      'Accuracy',
                      '${progress.overallAccuracy.toStringAsFixed(1)}%',
                      Icons.trending_up,
                      AppTheme.successColor,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: ScreenUtils.getPadding(all: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ScreenUtils.getRadius(12)),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ScreenUtils.getIconSize(24),
          ),
          SizedBox(height: ScreenUtils.getHeight(1)),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtils.getFontSize(18),
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtils.getFontSize(12),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'general knowledge':
        return Icons.public;
      case 'science':
        return Icons.science;
      case 'sports':
        return Icons.sports_soccer;
      case 'history':
        return Icons.history_edu;
      case 'geography':
        return Icons.map;
      case 'technology':
        return Icons.computer;
      case 'entertainment':
        return Icons.movie;
      case 'literature':
        return Icons.menu_book;
      default:
        return Icons.quiz;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'general knowledge':
        return Colors.blue;
      case 'science':
        return Colors.green;
      case 'sports':
        return Colors.orange;
      case 'history':
        return Colors.brown;
      case 'geography':
        return Colors.teal;
      case 'technology':
        return Colors.purple;
      case 'entertainment':
        return Colors.pink;
      case 'literature':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _startQuiz(BuildContext context, String category, QuizViewModel viewModel) {
    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {'category': category},
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }
}




