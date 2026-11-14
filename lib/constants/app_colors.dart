import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF171523);
  static const Color surfaceElevated = Color(0xFF211E31);
  static const Color card = Color(0xFF1E1B2E);

  // Accents & Gradients
  static const Color primaryPink = Color(0xFFFF3366);
  static const Color primaryPurple = Color(0xFFA138FF);
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color liveRed = Color(0xFFFF2A55);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF3B7A),
      Color(0xFFA63BFF),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF28233C),
      Color(0xFF181528),
    ],
  );

  static const LinearGradient sliderGradient = LinearGradient(
    colors: [
      Color(0xFFFF3B7A),
      Color(0xFFA63BFF),
    ],
  );

  // Typography & Subtles
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA5A1B8);
  static const Color textMuted = Color(0xFF6E6A82);

  // Borders & Dividers
  static const Color borderSubtle = Color(0xFF2A263D);
}

