import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildSocialButton extends StatelessWidget {
  const BuildSocialButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
    required this.label,
  });

  final VoidCallback onPressed;
  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
      ),
      label: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}