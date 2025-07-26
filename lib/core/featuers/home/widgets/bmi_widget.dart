import 'package:fitness/core/featuers/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmiWidget extends StatelessWidget {
  const BmiWidget({
    super.key,
    required this.size,
    required this.theme,
  });

  final Size size;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController value, Widget? child) {
        return GestureDetector(
          onTap: () {
            _showBmiDetails(context, value);
          },
          child: Container(
            height: 180,
            width: size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BMI (Body Mass Index)',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value.type ?? 'Not Calculated',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          color: theme.colorScheme.primaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCalculateButton(context),
                    ],
                  ),
                ),
                _BmiProgressIndicator(
                  value: value.bmi ?? 0.0, // Ensure null safety
                  size: size,
                  theme: theme,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalculateButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Stop propagation to prevent triggering parent GestureDetector
        context.read<HomeController>().calculateBmi();
      },
      behavior: HitTestBehavior.opaque, // Ensure button captures taps
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Calculate BMI',
          style: theme.textTheme.titleSmall!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showBmiDetails(BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.95),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BMI Details',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                controller.bmi != null
                    ? 'Your BMI: ${controller.bmi!.toStringAsFixed(1)} (${controller.type ?? 'Unknown'})'
                    : 'BMI: Not Calculated',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '18.5–24.9: Normal weight range',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BmiProgressIndicator extends StatefulWidget {
  const _BmiProgressIndicator({
    required this.value,
    required this.size,
    required this.theme,
  });

  final double value;
  final Size size;
  final ThemeData theme;

  @override
  State<_BmiProgressIndicator> createState() => _BmiProgressIndicatorState();
}

class _BmiProgressIndicatorState extends State<_BmiProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // Scale BMI (15–40 range) to 0–1, ensuring valid range
    final double scaledValue = widget.value > 0
        ? ((widget.value.clamp(15.0, 40.0) - 15.0) / (40.0 - 15.0))
        : 0.0;
    _animation = Tween<double>(
      begin: 0.0,
      end: scaledValue,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_BmiProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // Update animation when BMI value changes
      final double scaledValue = widget.value > 0
          ? ((widget.value.clamp(15.0, 40.0) - 15.0) / (40.0 - 15.0))
          : 0.0;
      _animation = Tween<double>(
        begin: _animation.value,
        end: scaledValue,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: _animation.value,
                backgroundColor: widget.theme.colorScheme.onSecondary.withOpacity(0.2),
                color: Colors.transparent,
                strokeWidth: 10,
                strokeAlign: BorderSide.strokeAlignOutside,
                strokeCap: StrokeCap.round,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
                semanticsLabel: 'BMI Progress',
                semanticsValue: '${(_animation.value * 100).toInt()}%',
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: CustomPaint(
                painter: _GradientArcPainter(
                  progress: _animation.value,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Text(
              widget.value > 0 ? widget.value.toStringAsFixed(1) : 'N/A',
              style: widget.theme.textTheme.titleMedium!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: widget.theme.colorScheme.primaryContainer,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GradientArcPainter extends CustomPainter {
  const _GradientArcPainter({
    required this.progress,
    required this.gradient,
  });

  final double progress;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -90 * (3.14159 / 180),
      2 * 3.14159 * progress.clamp(0.0, 1.0), // Ensure progress is valid
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}