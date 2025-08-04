import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FullBodyScreen extends StatefulWidget {
  const FullBodyScreen({super.key});

  @override
  State<FullBodyScreen> createState() => _FullBodyScreenState();
}

class _FullBodyScreenState extends State<FullBodyScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerAnimation;
  late Animation<double> _progressAnimation;

  List<Exercise> exercises = [
    Exercise(
      title: 'Warm Up',
      duration: '05:00',
      icon: FontAwesomeIcons.personRunning,
      description: 'Light cardio to prepare your body',
      calories: 25,
    ),
    Exercise(
      title: 'Push Ups',
      duration: '03:00',
      icon: FontAwesomeIcons.dumbbell,
      description: '3 sets of 15 reps',
      calories: 45,
    ),
    Exercise(
      title: 'Squats',
      duration: '04:00',
      icon: FontAwesomeIcons.personRunning,
      description: '3 sets of 20 reps',
      calories: 60,
    ),
    Exercise(
      title: 'Plank',
      duration: '02:30',
      icon: FontAwesomeIcons.personPraying,
      description: 'Hold for 30 seconds x 5',
      calories: 35,
    ),
    Exercise(
      title: 'Jumping Jacks',
      duration: '03:30',
      icon: FontAwesomeIcons.person,
      description: '3 sets of 30 reps',
      calories: 50,
    ),
    Exercise(
      title: 'Burpees',
      duration: '04:00',
      icon: FontAwesomeIcons.fire,
      description: '3 sets of 10 reps',
      calories: 80,
    ),
    Exercise(
      title: 'Mountain Climbers',
      duration: '03:00',
      icon: FontAwesomeIcons.mountain,
      description: '3 sets of 20 reps each leg',
      calories: 55,
    ),
    Exercise(
      title: 'Cool Down',
      duration: '05:00',
      icon: FontAwesomeIcons.leaf,
      description: 'Stretching and relaxation',
      calories: 20,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeInOut,
    ));

    _headerController.forward();
    _listController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  int get completedExercises => exercises.where((e) => e.isCompleted).length;
  int get totalCalories => exercises.fold(0, (sum, e) => sum + e.calories);
  int get completedCalories => exercises
      .where((e) => e.isCompleted)
      .fold(0, (sum, e) => sum + e.calories);
  double get progressPercentage => completedExercises / exercises.length;

  void _toggleExercise(int index) {
    setState(() {
      exercises[index].isCompleted = !exercises[index].isCompleted;
    });
  }

  void _startWorkout() {
    // Navigate to workout timer or detailed exercise view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.white),
            SizedBox(width: 8),
            Text('Starting workout...'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite_border, color: Colors.black87),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _headerAnimation.value)),
                  child: Opacity(
                    opacity: _headerAnimation.value,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF6C63FF),
                            const Color(0xFF4ECDC4),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned(
                            right: -50,
                            top: 50,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 80),
                                  Text(
                                    'Full Body',
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Workout',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                              
                                  // Stats Row
                                  Row(
                                    children: [
                                      _buildStatCard(
                                        icon: Icons.timer_outlined,
                                        value: '32',
                                        label: 'Minutes',
                                      ),
                                      const SizedBox(width: 16),
                                      _buildStatCard(
                                        icon: Icons.local_fire_department_outlined,
                                        value: totalCalories.toString(),
                                        label: 'Calories',
                                      ),
                                      const SizedBox(width: 16),
                                      _buildStatCard(
                                        icon: Icons.fitness_center_outlined,
                                        value: exercises.length.toString(),
                                        label: 'Exercises',
                                      ),
                                    ],
                                  ),
                              
                                  const SizedBox(height: 20),
                              
                                  // Progress Bar
                                  AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Progress',
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.9),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '$completedExercises/${exercises.length}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value: progressPercentage * _progressAnimation.value,
                                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                              minHeight: 6,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Exercise List
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ExerciseCard(
                              exercise: exercises[index],
                              onToggle: () => _toggleExercise(index),
                              theme: theme,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: exercises.length,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: AnimatedScale(
        scale: completedExercises == exercises.length ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.extended(
          onPressed: _startWorkout,
          backgroundColor: completedExercises == exercises.length
              ? Colors.green
              : const Color(0xFF6C63FF),
          icon: Icon(
            completedExercises == exercises.length
                ? Icons.check_circle
                : Icons.play_arrow,
            color: Colors.white,
          ),
          label: Text(
            completedExercises == exercises.length
                ? 'Complete!'
                : 'Start Workout',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onToggle;
  final ThemeData theme;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onToggle,
    required this.theme,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.exercise.isCompleted
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.exercise.isCompleted
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Exercise Icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: widget.exercise.isCompleted
                          ? Colors.green.withValues(alpha: 0.2)
                          : const Color(0xFF6C63FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.exercise.icon,
                      size: 28,
                      color: widget.exercise.isCompleted
                          ? Colors.green
                          : const Color(0xFF6C63FF),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Exercise Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.title,
                          style: widget.theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: widget.exercise.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: widget.exercise.isCompleted
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.exercise.description,
                          style: widget.theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.exercise.duration,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${widget.exercise.calories} cal',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Checkbox
                      GestureDetector(
                        onTap: widget.onToggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.exercise.isCompleted
                                ? Colors.green
                                : Colors.transparent,
                            border: Border.all(
                              color: widget.exercise.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: widget.exercise.isCompleted
                              ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Arrow Button
                      IconButton(
                        onPressed: () {
                          // Navigate to exercise detail
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 16,
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

class Exercise {
  final String title;
  final String duration;
  final IconData icon;
  final String description;
  final int calories;
  bool isCompleted;

  Exercise({
    required this.title,
    required this.duration,
    required this.icon,
    required this.description,
    required this.calories,
    this.isCompleted = false,
  });
}