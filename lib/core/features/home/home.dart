import 'package:fitness/core/features/home/widgets/app_bar.dart';
import 'package:fitness/core/features/home/widgets/bmi_widget.dart';
import 'package:fitness/core/features/home/widgets/target_today.dart';
import 'package:fitness/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'activity/activity.dart';
import 'controller/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final controller = context.read<HomeController>();
    final isMobile = ResponsiveUtils.isMobile(context);
    final spacing = ResponsiveUtils.getSpacing(context, 30);
    
    return SingleChildScrollView(
      child: Padding(
        padding: ResponsiveUtils.getHorizontalPadding(context),
        child: ResponsiveUtils.constrainedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * APP BAR  WELCOME , Name User And Notification
              AppBarWidget(theme: theme),
              SizedBox(height: spacing * 0.8),
              BmiWidget(size: size, theme: theme),
              SizedBox(height: spacing * 0.8),
              TodayTargetWidget(
                size: size,
                theme: theme,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Activity();
                      },
                    ),
                  );
                  // Add this line to refresh the water size when returning from Activity screen
                  context.read<HomeController>().refresh();
                },
              ),
              SizedBox(height: spacing),
              Text(
                'Activity Status',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: ResponsiveUtils.getFontSize(context, 16),
                ),
              ),
              SizedBox(height: spacing * 0.8),
              // ********************* Activity Status ********************
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<HomeController>(
                    builder: (context, provider, child) {
                      return _buildContainer(
                        context: context,
                        theme: theme,
                        icon: FontAwesomeIcons.personRunning,
                        title: 'Step',
                        counter: provider.stepsCounter.toString(),
                      );
                    },
                  ),
                  Consumer<HomeController>(
                    builder: (context, provider, child) {
                      return _buildContainer(
                        context: context,
                        theme: theme,
                        icon: FontAwesomeIcons.map,
                        title: 'Distance Km',
                        counter: provider.distance.toStringAsFixed(2),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: spacing),
              _buildWaterAndHealthSection(context, theme, size, controller, isMobile, spacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaterAndHealthSection(BuildContext context, ThemeData theme, Size size, HomeController controller, bool isMobile, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Water Intake Widget
        _buildWaterIntakeWidget(context, theme, size, controller, isMobile),
        SizedBox(width: spacing * 0.5),
        // Sleep and Calories Column
        Expanded(
          child: Column(
            children: [
              _buildSleepWidget(context, theme, isMobile),
              SizedBox(height: ResponsiveUtils.getSpacing(context, 15)),
              _buildCaloriesWidget(context, theme, isMobile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaterIntakeWidget(BuildContext context, ThemeData theme, Size size, HomeController controller, bool isMobile) {
    return Flexible(
      flex: isMobile ? 1 : 2,
      child: InkWell(
        onTap: () => _showWaterDialog(context, theme, size, controller),
        child: Container(
          height: ResponsiveUtils.getContainerHeight(context, 315),
          constraints: BoxConstraints(
            maxWidth: isMobile ? 170 : 220,
            minWidth: 140,
          ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, 14),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Consumer<HomeController>(
            builder: (BuildContext context, value, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SimpleAnimationProgressBar(
                    height: size.height * 0.3,
                    width: ResponsiveUtils.getSpacing(context, 30),
                    backgroundColor: Color(0xffF7F8F8),
                    foregroundColor: Color(0xffB4C0FE),
                    ratio: value.startWater ?? 0.0,
                    direction: Axis.vertical,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(seconds: 3),
                    borderRadius: BorderRadius.circular(17),
                    gradientColor: const LinearGradient(
                      colors: [Color(0xffB4C0FE), Color(0xffB4C0FE)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Water Intake',
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontSize: ResponsiveUtils.getFontSize(context, 18),
                          ),
                        ),
                        Selector<HomeController, double?>(
                          selector: (context, provider) => provider.targetWaterToday,
                          builder: (context, targetValue, child) {
                            return Text(
                              '$targetValue Liters',
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: theme.colorScheme.primaryContainer,
                                fontSize: ResponsiveUtils.getFontSize(context, 21),
                              ),
                            );
                          },
                        ),
                        Text(
                          'Real time updates',
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.intakeDataNew.length,
                            itemBuilder: (context, index) {
                              final obj = value.intakeDataNew[index];
                              final isActive = obj['isActive'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: isActive ? Colors.purple : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      margin: const EdgeInsets.only(right: 8.0, top: 2.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${obj["time"] ?? 'N/A'}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text(
                                            "${obj["amount"] ?? 0}ml",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isActive ? Colors.purple : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSleepWidget(BuildContext context, ThemeData theme, bool isMobile) {
    return InkWell(
      onTap: () => _showSleepEditDialog(context, theme),
      child: Container(
        height: ResponsiveUtils.getContainerHeight(context, 150),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xffB4C0FE).withValues(alpha: 0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xffB4C0FE).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, 18),
          ),
          border: Border.all(
            color: Color(0xffB4C0FE).withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffB4C0FE).withValues(alpha: 0.2),
                      Color(0xffB4C0FE).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.hotel,
                  color: Color(0xffB4C0FE),
                  size: ResponsiveUtils.getIconSize(context, 24),
                ),
              ),
              Text(
                'Sleep',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(context, 16),
                  color: Color(0xff1D1617),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Consumer<HomeController>(
                builder: (context, provider, child) {
                  return Text(
                    provider.sleepDisplay,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: ResponsiveUtils.getFontSize(context, 22),
                      fontWeight: FontWeight.bold,
                      color: Color(0xffB4C0FE),
                    ),
                  );
                },
              ),
              SvgPicture.asset(
                'assets/home/Sleep-Graph.svg',
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesWidget(BuildContext context, ThemeData theme, bool isMobile) {
    return InkWell(
      onLongPress: () => _showCaloriesRestDialog(context, theme),
      child: Container(
        height: ResponsiveUtils.getContainerHeight(context, 150),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.orange.withValues(alpha: 0.08),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, 18),
          ),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withValues(alpha: 0.2),
                      Colors.orange.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.orange,
                  size: ResponsiveUtils.getIconSize(context, 24),
                ),
              ),
              Text(
                'Calories',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(context, 16),
                  color: Color(0xff1D1617),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Consumer<HomeController>(
                builder: (context, provider, child) {
                  return Text(
                    '${provider.calories.toInt()} kCal',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: ResponsiveUtils.getFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  );
                },
              ),
              Consumer<HomeController>(
                builder: (context, provider, child) {
                  final remaining = (1000 - provider.calories.toInt()).clamp(0, 1000);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          value: provider.calories / 1000,
                          backgroundColor: Color(0xffF7F8F8),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                          strokeWidth: 5,
                        ),
                      ),
                      Text(
                        '$remaining',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
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
    );
  }

  void _showWaterDialog(BuildContext context, ThemeData theme, Size size, HomeController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.isMobile(context) ? size.width * 0.9 : 500,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Water Intake',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<HomeController>(
                  builder: (context, controller, child) {
                    return Text(
                      '${controller.currentWaterIntake.toInt()} ml',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Icon(
                  FontAwesomeIcons.glassWater,
                  size: 60,
                  color: Colors.lightBlue,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWaterControl(controller, 250),
                    _buildWaterControl(controller, 500),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 40),
                  ),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterControl(HomeController controller, int amount) {
    return Column(
      children: [
        Text(
          '$amount ml',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () => controller.decrementWater(amount.toDouble()),
              icon: Icon(FontAwesomeIcons.circleMinus),
              color: Colors.red,
            ),
            IconButton(
              onPressed: () => controller.incrementWater(amount.toDouble()),
              icon: Icon(FontAwesomeIcons.circlePlus),
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  TweenAnimationBuilder<double> _buildContainer({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String counter,
  }) {
    final colorScheme = title == 'Step' 
        ? [Colors.deepOrange.withValues(alpha: 0.15), Colors.orange.withValues(alpha: 0.05)]
        : [Colors.blue.withValues(alpha: 0.15), Colors.lightBlue.withValues(alpha: 0.05)];
    final iconColor = title == 'Step' ? Colors.deepOrange : Colors.blue;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, 10)),
            height: ResponsiveUtils.getContainerHeight(context, 150),
            width: ResponsiveUtils.getCardWidth(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ...colorScheme],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withValues(alpha: 0.2),
                        iconColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon, 
                    color: iconColor,
                    size: 26,
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: double.tryParse(counter.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Text(
                      title == 'Distance Km' ? value.toStringAsFixed(2) : value.toInt().toString(),
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontSize: ResponsiveUtils.getFontSize(context, 32),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    );
                  },
                ),
                Text(
                  title,
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: ResponsiveUtils.getFontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Enhanced Calories Rest Dialog
  void _showCaloriesRestDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Title
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffB4C0FE).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: Color(0xffB4C0FE),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Reset Calories?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1D1617),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Consumer<HomeController>(
                  builder: (context, provider, child) {
                    return Text(
                      'Current: ${provider.calories.toInt()} / 1000 kCal\nWould you like to reset your calorie tracking?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [Color(0xffB4C0FE), Color(0xff9BB5FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffB4C0FE).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _resetCalories(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
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
  }

  // Reset Calories Method
  void _resetCalories(BuildContext context) {
    // Reset calories in your provider
    final provider = Provider.of<HomeController>(context, listen: false);
    provider
        .resetCalories(); // You need to add this method to your HomeController

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Calories reset successfully!',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Color(0xffB4C0FE),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  // Sleep Edit Dialog
  void _showSleepEditDialog(BuildContext context, ThemeData theme) {
    final provider = Provider.of<HomeController>(context, listen: false);
    int selectedHours = provider.sleepHours;
    int selectedMinutes = provider.sleepMinutes;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Color(0xffB4C0FE).withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Header
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffB4C0FE), Color(0xff9BB5FF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffB4C0FE).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.hotel,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      'Edit Sleep Duration',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1D1617),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adjust your sleep time',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Hours and Minutes Pickers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Hours
                        _buildTimePicker(
                          label: 'Hours',
                          value: selectedHours,
                          max: 24,
                          onIncrement: () => setState(() {
                            if (selectedHours < 24) selectedHours++;
                          }),
                          onDecrement: () => setState(() {
                            if (selectedHours > 0) selectedHours--;
                          }),
                        ),
                        
                        // Minutes
                        _buildTimePicker(
                          label: 'Minutes',
                          value: selectedMinutes,
                          max: 59,
                          onIncrement: () => setState(() {
                            if (selectedMinutes < 59) selectedMinutes++;
                          }),
                          onDecrement: () => setState(() {
                            if (selectedMinutes > 0) selectedMinutes--;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [Color(0xffB4C0FE), Color(0xff9BB5FF)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffB4C0FE).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                provider.updateSleep(selectedHours, selectedMinutes);
                                Navigator.of(context).pop();
                                
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Sleep duration updated!',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Color(0xffB4C0FE),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    margin: EdgeInsets.all(16),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
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

  Widget _buildTimePicker({
    required String label,
    required int value,
    required int max,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff1D1617),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xffB4C0FE).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: onIncrement,
                icon: Icon(Icons.arrow_drop_up, size: 32),
                color: Color(0xffB4C0FE),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1D1617),
                  ),
                ),
              ),
              IconButton(
                onPressed: onDecrement,
                icon: Icon(Icons.arrow_drop_down, size: 32),
                color: Color(0xffB4C0FE),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
