import 'package:flutter/material.dart';

// Defines the light theme configuration for the Flutter application
ThemeData lightTheme = ThemeData(
  // Set Poppins as the default font family for the entire app
  fontFamily: 'Poppins',

  // Configure the theme for ElevatedButton widgets
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Color(0xFF1D1617),
      foregroundColor: Color(0xFFFFFFFF),
    ),
  ),

  // Configure the theme for FloatingActionButton widgets
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF86A8E7), // Soft blue background
    foregroundColor: Colors.white, // White icon/text color
    elevation: 2, // Light shadow for depth
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)), // Circular shape
    ),
  ),

  // Define the color scheme for the light theme
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1D1617),
    onPrimary: Color(0xFFFFFFFF),// Dark gray for text and backgrounds
    secondary: Color(0xFF86A8E7), // Soft blue for accents
    onSecondary:   Color(0xffC58BF2),
    surface: Color(0xFFFFFFFF),
    primaryContainer: Color(0xff92A3FD)
    // White for cards and containers
  ),

  // Define text styles for various text categories
  textTheme: const TextTheme(
    labelSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white
    ),
    // Small headline style, typically for smaller headings
    headlineSmall: TextStyle(
      color: Color(0xffC58BF2),
      fontSize: 16,
      fontWeight: FontWeight.w700, // Bold weight
    ),
    // Small display text, used for input field hints
    displaySmall: TextStyle(
      color: Color(0xFFADA4A5), // Muted gray for placeholders
      fontSize: 12,
      fontWeight: FontWeight.w400, // Regular weight
    ),
    // Medium display text, used for standard text content
    displayMedium: TextStyle(
      color: Color(0xFF1D1617), // Dark gray for readability
      fontSize: 16,
      fontWeight: FontWeight.w400, // Regular weight
    ),
    // Small title text, used for secondary titles or labels
    titleSmall: TextStyle(
      color: Color(0xFF7B6F72), // Muted gray for secondary text
      fontSize: 18,
      fontWeight: FontWeight.w400, // Regular weight
    ),
    // Medium title text, used for main headings
    titleMedium: TextStyle(
      color: Color(0xFF1D1617), // Dark gray for headings
      fontSize: 24,
      fontWeight: FontWeight.w600, // Semi-bold weight
    ),
    // Large title text, used for prominent headings
    titleLarge: TextStyle(
      color: Color(0xFF1D1617), // Dark gray for emphasis
      fontSize: 36,
      fontWeight: FontWeight.w700, // Bold weight
    ),
    // Medium body text, used for general content
    bodyMedium: TextStyle(
      color: Color(0xFF1D1617), // Dark gray for readability
      fontSize: 16,
      fontWeight: FontWeight.w400, // Regular weight
    ),
  ),
);