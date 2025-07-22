import 'package:flutter/material.dart';

class TodayTargetWidget extends StatefulWidget {
  const TodayTargetWidget({
    super.key,
    required this.size,
    required this.theme,
    this.onTap,
  });

  final Size size;
  final ThemeData theme;
  final VoidCallback? onTap;

  @override
  State<TodayTargetWidget> createState() => _TodayTargetWidgetState();
}

class _TodayTargetWidgetState extends State<TodayTargetWidget> with SingleTickerProviderStateMixin {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 60,
        width: widget.size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9AC1FE), Color(0xFF9DCEFF)],
            stops: [0, 0.5, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today Target",
                style: widget.theme.textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              _buildCheckButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isTapped ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "Check",
            style: widget.theme.textTheme.titleSmall!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF92A3FD),
            ),
            semanticsLabel: "Check Today Target",
          ),
        ),
      ),
    );
  }
}