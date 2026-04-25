import 'package:fitness/core/features/workout/subScreen/controller_shared_screen/controller_sub_screen.dart';
import 'package:fitness/core/features/workout/subScreen/exercice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fitness/widgets/insufficient_coins_dialog.dart';

import '../../../services_ads_storage_local/coin_service.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Choose Your',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Workout',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start your fitness journey today',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildWorkoutCard(
                        theme: theme,
                        title: 'Full Body Workout',
                        subTitle: '11 Exercises • 32 mins',
                        difficulty: 'Intermediate',
                        calories: '320 kcal',
                        color: const Color(0xFF6C63FF),
                        iconPath: 'assets/home/Vector.svg',
                        onPressed: () => _navigateToWorkout(
                          context,
                          level: 'Intermediate',
                          partOf: 'Full Body Workout',
                        ),
                        delay: 0,
                      ),
                      const SizedBox(height: 20),
                      _buildWorkoutCard(
                        theme: theme,
                        title: 'Lower Body Workout',
                        subTitle: '9 Exercises • 28 mins',
                        difficulty: 'Beginner',
                        calories: '280 kcal',
                        color: const Color(0xFF4ECDC4),
                        iconPath: 'assets/home/Vector.svg',
                        onPressed: () => _navigateToWorkout(
                          context,
                          level: 'Beginner',
                          partOf: 'Lower Body Workout',
                        ),
                        delay: 200,
                      ),
                      const SizedBox(height: 20),
                      _buildWorkoutCard(
                        theme: theme,
                        title: 'AB Workout',
                        subTitle: '8 Exercises • 20 mins',
                        difficulty: 'Advanced',
                        calories: '240 kcal',
                        color: const Color(0xFFFF6B9D),
                        iconPath: 'assets/home/Vector.svg',
                        onPressed: () => _navigateToWorkout(
                          context,
                          level: 'Advanced',
                          partOf: 'AB Workout',
                        ),
                        delay: 400,
                      ),
                      const SizedBox(height: 20),
                      _buildWorkoutCard(
                        theme: theme,
                        title: 'Upper Body Workout',
                        subTitle: '10 Exercises • 30 mins',
                        difficulty: 'Intermediate',
                        calories: '300 kcal',
                        color: const Color(0xFFFFA726),
                        iconPath: 'assets/home/Vector.svg',
                        onPressed: () => _navigateToWorkout(
                          context,
                          level: 'Intermediate',
                          partOf: 'Upper Body Workout',
                        ),
                        delay: 600,
                      ),
                      const SizedBox(height: 30),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToWorkout(
    BuildContext context, {
    required String level,
    required String partOf,
  }) async {
    final coinService = Provider.of<CoinService>(context, listen: false);

    if (!coinService.canAffordExercise()) {
      final result = await showInsufficientCoinsDialog(
        context,
        currentCoins: coinService.coins,
        requiredCoins: coinService.exerciseCost,
      );

      if (result == true && coinService.canAffordExercise()) {
        await _proceedWithWorkout(context, coinService, level, partOf);
      }
    } else {
      await _proceedWithWorkout(context, coinService, level, partOf);
    }
  }

  Future<void> _proceedWithWorkout(
    BuildContext context,
    CoinService coinService,
    String level,
    String partOf,
  ) async {
    final success = await coinService.purchaseExercise();

    if (success && mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ChangeNotifierProvider(
                create: (BuildContext context) => ControllerSubScreen(),
                child: FullBodyScreen(level: level, partOf: partOf),
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  Widget _buildWorkoutCard({
    required ThemeData theme,
    required String title,
    required String subTitle,
    required String difficulty,
    required String calories,
    required Color color,
    required String iconPath,
    required VoidCallback onPressed,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _EnhancedWorkoutCard(
        theme: theme,
        title: title,
        subTitle: subTitle,
        difficulty: difficulty,
        calories: calories,
        color: color,
        iconPath: iconPath,
        onPressed: onPressed,
      ),
    );
  }
}

class _EnhancedWorkoutCard extends StatefulWidget {
  const _EnhancedWorkoutCard({
    required this.theme,
    required this.title,
    required this.subTitle,
    required this.difficulty,
    required this.calories,
    required this.color,
    required this.iconPath,
    required this.onPressed,
  });

  final ThemeData theme;
  final String title;
  final String subTitle;
  final String difficulty;
  final String calories;
  final Color color;
  final String iconPath;
  final VoidCallback onPressed;

  @override
  State<_EnhancedWorkoutCard> createState() => _EnhancedWorkoutCardState();
}

class _EnhancedWorkoutCardState extends State<_EnhancedWorkoutCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  String _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '⭐';
      case 'intermediate':
        return '⭐⭐';
      case 'advanced':
        return '⭐⭐⭐';
      default:
        return '⭐';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _hoverController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.98 : _scaleAnimation.value,
            child: Container(
              // Remove fixed height constraint, let content determine height
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.color, widget.color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background decorative circles
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    bottom: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // Main content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left content section
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Difficulty badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 8 : 12,
                                vertical: isSmallScreen ? 4 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getDifficultyIcon(widget.difficulty),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 10 : 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.difficulty,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 10 : 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 8 : 12),

                            // Title
                            Text(
                              widget.title,
                              style: widget.theme.textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    fontSize: isSmallScreen ? 18 : 22,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isSmallScreen ? 4 : 8),

                            // Subtitle
                            Text(
                              widget.subTitle,
                              style: widget.theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // Calories
                            Text(
                              widget.calories,
                              style: widget.theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: isSmallScreen ? 11 : 13,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),

                            // Start button
                            Container(
                              height: isSmallScreen ? 36 : 40,
                              constraints: BoxConstraints(
                                maxWidth: isSmallScreen ? 130 : 160,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: widget.onPressed,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 12 : 16,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Start Workout',
                                            style: TextStyle(
                                              color: widget.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: isSmallScreen ? 12 : 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: widget.color,
                                          size: isSmallScreen ? 18 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right icon section
                      SizedBox(
                        width: isSmallScreen ? 70 : 90,
                        height: isSmallScreen ? 70 : 90,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: isSmallScreen ? 60 : 80,
                              height: isSmallScreen ? 60 : 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            Container(
                              width: isSmallScreen ? 45 : 60,
                              height: isSmallScreen ? 45 : 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            SizedBox(
                              width: isSmallScreen ? 35 : 45,
                              height: isSmallScreen ? 35 : 45,
                              child: SvgPicture.asset(
                                widget.iconPath,
                                width: isSmallScreen ? 35 : 45,
                                height: isSmallScreen ? 35 : 45,
                                fit: BoxFit.contain,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
