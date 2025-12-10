import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/meal_model.dart';
import 'controller/nutrition_controller.dart';
import 'add_meal_screen.dart';
import 'barcode_scanner_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NutritionController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<NutritionController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[ 
              // Header
              Text(
                'Nutrition Tracker',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Daily Calorie Progress
              _buildCalorieCard(context, controller),
              const SizedBox(height: 20),
              
              // Macro Breakdown
              _buildMacrosCard(context, controller),
              const SizedBox(height: 20),
              
              // Water Intake
              _buildWaterCard(context, controller),
              const SizedBox(height: 20),
              
              // Quick Actions
              _buildQuickActions(context),
              const SizedBox(height: 20),
              
              // Meals List
              _buildMealsList(context, controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalorieCard(BuildContext context, NutritionController controller) {
    final theme = Theme.of(context);
    final consumed = controller.totalCalories;
    final goal = controller.dailyCalorieGoal;
    final remaining = goal - consumed;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${consumed.toInt()} / ${goal.toInt()} kcal',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
              CircularProgressIndicator(
                value: controller.calorieProgress / 100,
                strokeWidth: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  remaining >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: controller.calorieProgress / 100,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              remaining >= 0 ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            remaining >= 0
                ? '${remaining.toInt()} kcal remaining'
                : '${(-remaining).toInt()} kcal over',
            style: theme.textTheme.bodySmall?.copyWith(
              color: remaining >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosCard(BuildContext context, NutritionController controller) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macronutrients',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Protein
          _buildMacroRow(
            'Protein',
            controller.totalProtein,
            controller.dailyProteinGoal,
            controller.proteinProgress,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          
          // Carbs
          _buildMacroRow(
            'Carbs',
            controller.totalCarbs,
            controller.dailyCarbsGoal,
            controller.carbsProgress,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          
          // Fats
          _buildMacroRow(
            'Fats',
            controller.totalFats,
            controller.dailyFatsGoal,
            controller.fatsProgress,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String name, double consumed, double goal, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${consumed.toInt()}g / ${goal.toInt()}g'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress / 100,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ],
    );
  }

  Widget _buildWaterCard(BuildContext context, NutritionController controller) {
    final theme = Theme.of(context);
    final consumed = controller.totalWater;
    final goal = controller.dailyWaterGoal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water Intake',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(consumed / 1000).toStringAsFixed(1)}L / ${(goal / 1000).toStringAsFixed(1)}L',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: controller.waterProgress / 100,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Colors.blue),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildWaterButton(context, 250, '250ml')),
              const SizedBox(width: 8),
              Expanded(child: _buildWaterButton(context, 500, '500ml')),
              const SizedBox(width: 8),
              Expanded(child: _buildWaterButton(context, 750, '750ml')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterButton(BuildContext context, double amount, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await context.read<NutritionController>().addWaterIntake(amount);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added $label of water! 💧'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick  Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Add Meal',
                Icons.restaurant,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddMealScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Scan Barcode',
                Icons.qr_code_scanner,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsList(BuildContext context, NutritionController controller) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Meals',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (controller.meals.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No meals logged yet.\nTap "Add Meal" to get started!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.meals.length,
            itemBuilder: (context, index) {
              final meal = controller.meals[index];
              return _buildMealCard(context, meal);
            },
          ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, Meal meal) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets. only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meal.mealType.toString().split('.').last.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${meal.calories.toInt()} cal • P${meal.protein.toInt()}g • C${meal.carbs.toInt()}g • F${meal.fats.toInt()}g',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteConfirmation(context, meal);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Meal meal) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Meal'),
        content: Text('Are you sure you want to delete "${meal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NutritionController>().deleteMeal(meal.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
