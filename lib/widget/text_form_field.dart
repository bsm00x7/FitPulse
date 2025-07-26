import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.source,
    required this.hint,
    required this.controller,
    required this.errorValidator,
    this.anotherSource,
    required this.keyboardType,
    required this.obscureText,
    this.inputFormatters, // Added inputFormatters
    this.validator, // Added custom validator
  });

  final String source;
  final String? anotherSource;
  final String hint;
  final TextEditingController controller;
  final String errorValidator;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      obscureText: obscureText,
      maxLines: 1,
      maxLength: 35,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // Apply input formatters
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F8F8),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(
            source,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              theme.iconTheme.color ?? Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ),
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey,
        ),
        suffixIcon: anotherSource != null
            ? Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SvgPicture.asset(
            anotherSource!,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              theme.iconTheme.color ?? Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        )
            : null,
        counterText: '', // Hides the character counter
      ),
      controller: controller,
      validator: validator ?? (String? value) {
        if (value == null || value.trim().isEmpty) {
          return errorValidator;
        }
        return null;
      },
    );
  }
}