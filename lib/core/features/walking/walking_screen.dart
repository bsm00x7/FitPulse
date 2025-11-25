import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'controller/walking_controllerprovider.dart';

class WalkingScreen extends StatelessWidget {
  const WalkingScreen({super.key});

  // Get motivational message based on progress
  String _getMotivationalMessage(double progress) {
    if (progress >= 1.5) return "🔥 You're unstoppable!";
    if (progress >= 1.0) return '🎉 Goal crushed!';
    if (progress >= 0.75) return '💪 Almost there!';
    if (progress >= 0.5) return '🚶 Halfway milestone!';
    if (progress >= 0.25) return '✨ Great start!';
    return "👟 Let's get moving!";
  }

  // Get achievement badge based on progress
  List<Widget> _getAchievementBadges(double progress, double screenWidth) {
    final badges = <Widget>[];
    final milestones = [
      (0.25, '25%', Colors.blue),
      (0.5, '50%', Colors.purple),
      (0.75, '75%', Colors.orange),
      (1.0, '100%', Colors.green),
      (1.5, '150%', Colors.pink),
    ];

    for (var milestone in milestones) {
      badges.add(_buildBadge(
        milestone.$2,
        milestone.$3,
        progress >= milestone.$1,
        screenWidth,
      ));
    }
    return badges;
  }

  Widget _buildBadge(String label, Color color, bool achieved, double screenWidth) {
    final badgeSize = screenWidth * 0.12; // 12% of screen width
    final fontSize = screenWidth * 0.028; // Responsive font size
    
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: achieved ? color : Colors.grey[300],
        boxShadow: achieved
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: achieved ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress, Color primaryColor) {
    if (progress >= 1.5) return Colors.pink;
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.75) return Colors.orange;
    if (progress >= 0.5) return Colors.purple;
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive sizing factors
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    
    return ChangeNotifierProvider(
      create: (BuildContext context) => WalkingControllerProvider(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<WalkingControllerProvider>(
            builder: (context, provider, child) {
              return RefreshIndicator(
                onRefresh: () async {
                  await provider.refresh();
                },
                color: theme.primaryColor,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: screenHeight * 0.1,
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          'Walking Tracker',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    // Main Content
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SizedBox(height: screenHeight * 0.012),
                          _buildMotivationalBanner(context, theme, screenWidth),
                          SizedBox(height: screenHeight * 0.024),
                          _buildMainProgressCard(context, theme, screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.02),
                          _buildStreakBadge(context, theme, screenWidth, provider),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAchievementSection(context, theme, screenWidth),
                          SizedBox(height: screenHeight * 0.03),
                          _buildStatsSection(context, theme, screenWidth),
                          SizedBox(height: screenHeight * 0.03),
                          _buildWeeklyHistoryChart(context, theme, screenWidth, provider),
                          SizedBox(height: screenHeight * 0.03),
                          _buildTargetCard(context, theme, screenWidth),
                          SizedBox(height: screenHeight * 0.03),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  // NEW: Streak badge widget
  Widget _buildStreakBadge(BuildContext context, ThemeData theme, double screenWidth, WalkingControllerProvider provider) {
    if (provider.currentStreak == 0) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.15),
            Colors.deepOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: screenWidth * 0.06,
          ),
          SizedBox(width: 8),
          Text(
            '${provider.currentStreak} Day Streak!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
  
  // NEW: Weekly history chart widget
  Widget _buildWeeklyHistoryChart(BuildContext context, ThemeData theme, double screenWidth, WalkingControllerProvider provider) {
    final chartData = provider.weeklyChartData;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Weekly Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              letterSpacing: 0.3,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Chart bars
              SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: chartData.map((data) {
                    final steps = data['steps'] as int;
                    final goalMet = data['goalMet'] as bool;
                    final maxSteps = provider.targetsSteps * 1.5;
                    final heightFactor = (steps / maxSteps).clamp(0.0, 1.0);
                    
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Bar
                            AnimatedContainer(
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeOut,
                              height: 120 * heightFactor,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: goalMet
                                      ? [Colors.green, Colors.lightGreen]
                                      : [theme.primaryColor.withValues(alpha: 0.6), theme.primaryColor.withValues(alpha: 0.3)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(height: 8),
                            // Day label
                            Text(
                              data['day'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(Colors.green, 'Goal Met', theme),
                  SizedBox(width: 20),
                  _buildLegendItem(theme.primaryColor.withValues(alpha: 0.6), 'In Progress', theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(Color color, String label, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[700],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationalBanner(BuildContext context, ThemeData theme, double screenWidth) {
    final fontSize = screenWidth * 0.042; // Responsive font size
    
    return Consumer<WalkingControllerProvider>(
      builder: (context, provider, child) {
        final message = _getMotivationalMessage(provider.progressPercentage);
        final progressColor = _getProgressColor(
          provider.progressPercentage,
          theme.primaryColor,
        );

        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenWidth * 0.03,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                progressColor.withValues(alpha: 0.15),
                progressColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: progressColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: progressColor,
                  letterSpacing: 0.3,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainProgressCard(BuildContext context, ThemeData theme, double screenWidth, double screenHeight) {
    final lottieHeight = screenHeight * 0.13;
    final progressSize = screenWidth * 0.42;
    final centerCircleSize = screenWidth * 0.32;
    final stepFontSize = screenWidth * 0.085;
    final cardPadding = screenWidth * 0.07;

    return Consumer<WalkingControllerProvider>(
      builder: (context, provider, child) {
        final progressColor = _getProgressColor(
          provider.progressPercentage,
          theme.primaryColor,
        );

        return Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                progressColor.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: progressColor.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Animated Lottie
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: Opacity(
                      opacity: value,
                      child: SizedBox(
                        height: lottieHeight,
                        child: Lottie.asset(
                          'assets/lottis_json/Walking steps.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Progress Circle with Glassmorphism
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect
                  Container(
                    width: progressSize + 20,
                    height: progressSize + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          progressColor.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Progress Circle
                  SimpleCircularProgressBar(
                    valueNotifier: ValueNotifier(provider.steps.toDouble()),
                    maxValue: provider.targetsSteps.toDouble(),
                    backColor: Colors.grey[200]!,
                    size: progressSize,
                    progressStrokeWidth: screenWidth * 0.037,
                    backStrokeWidth: screenWidth * 0.037,
                    progressColors: [
                      progressColor,
                      progressColor.withValues(alpha: 0.6),
                    ],
                    fullProgressColor: Colors.green,
                  ),

                  // Center Content with Glassmorphism
                  ClipRRect(
                    borderRadius: BorderRadius.circular(centerCircleSize / 2),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: centerCircleSize,
                        height: centerCircleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.7),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: provider.steps.toDouble(),
                              ),
                              duration: const Duration(milliseconds: 1000),
                              builder: (context, value, child) {
                                return Text(
                                  value.toInt().toString(),
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: progressColor,
                                    fontSize: stepFontSize,
                                  ),
                                );
                              },
                            ),
                            Text(
                              'steps',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: progressColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(provider.progressPercentage * 100).toInt()}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: progressColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementSection(BuildContext context, ThemeData theme, double screenWidth) {
    return Consumer<WalkingControllerProvider>(
      builder: (context, provider, child) {
        final badges = _getAchievementBadges(provider.progressPercentage, screenWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Achievements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: badges,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, ThemeData theme, double screenWidth) {
    final cardSpacing = screenWidth * 0.03;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Today\'s Activity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              letterSpacing: 0.3,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedStatCard(
                context,
                theme,
                'Calories',
                FontAwesomeIcons.fire,
                Colors.orange,
                screenWidth,
              ),
            ),
            SizedBox(width: cardSpacing),
            Expanded(
              child: _buildEnhancedStatCard(
                context,
                theme,
                'Distance',
                FontAwesomeIcons.route,
                Colors.blue,
                screenWidth,
              ),
            ),
          ],
        ),
        SizedBox(height: cardSpacing),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedStatCard(
                context,
                theme,
                'Time Active',
                FontAwesomeIcons.clock,
                Colors.purple,
                screenWidth,
              ),
            ),
            SizedBox(width: cardSpacing),
            Expanded(
              child: _buildEnhancedStatCard(
                context,
                theme,
                'Avg Pace',
                FontAwesomeIcons.gaugeHigh,
                Colors.teal,
                screenWidth,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedStatCard(
    BuildContext context,
    ThemeData theme,
    String label,
    IconData icon,
    Color iconColor,
    double screenWidth,
  ) {
    final cardPadding = screenWidth * 0.045;
    final iconSize = screenWidth * 0.055;
    final iconPadding = screenWidth * 0.025;
    
    return Consumer<WalkingControllerProvider>(
      builder: (context, provider, child) {
        String value;
        String unit;

        switch (label) {
          case 'Calories':
            value = provider.calories.toStringAsFixed(0);
            unit = 'kcal';
            break;
          case 'Distance':
            value = provider.distance.toStringAsFixed(1);
            unit = 'km';
            break;
          case 'Time Active':
            // Estimate: ~1000-1200 steps per 10 minutes of walking
            final minutes = (provider.steps / 100).toInt();
            value = minutes.toString();
            unit = 'min';
            break;
          case 'Avg Pace':
            // Estimate: avg walking pace (steps per minute)
            final pace = provider.steps > 0 ? 100 : 0;
            value = pace.toString();
            unit = 'spm';
            break;
          default:
            value = '0';
            unit = '';
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          builder: (context, animValue, child) {
            return Transform.scale(
              scale: 0.95 + (animValue * 0.05),
              child: Container(
                padding: EdgeInsets.all(cardPadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      iconColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(iconPadding),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            iconColor.withValues(alpha: 0.2),
                            iconColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: iconSize),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          unit,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '• $label',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTargetCard(BuildContext context, ThemeData theme, double screenWidth) {
    final cardPadding = screenWidth * 0.05;
    final iconSize = screenWidth * 0.05;
    
    return Consumer<WalkingControllerProvider>(
      builder: (context, provider, child) {
        final progress = provider.progressPercentage;
        final progressColor = _getProgressColor(progress, theme.primaryColor);

        return Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                progressColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: progressColor.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: progressColor.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: progressColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      FontAwesomeIcons.bullseye,
                      color: progressColor,
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Today\'s Goal',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: 0.3,
                      fontSize: 17
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${provider.targetsSteps}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: progressColor,
                          ),
                        ),
                        Text(
                          'steps target',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          progressColor.withValues(alpha: 0.2),
                          progressColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: value.clamp(0.0, 1.0),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  progressColor,
                                  progressColor.withValues(alpha: 0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: progressColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (progress >= 1.0) ...[
                SizedBox(height: screenWidth * 0.04),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withValues(alpha: 0.15),
                        Colors.green.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.celebration,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Goal Achieved!',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Keep up the great work! 🎉',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
