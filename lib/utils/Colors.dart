import 'package:flutter/material.dart';

class AppColorsForApp {
  // Black shades (Primary)
  static const Color blackPrimary = Color(0xFF121212);
  static const Color blackSecondary = Color(0xFF1E1E1E);
  static const Color blackAccent = Color(0xFF2A2A2A);
  
  // Blue shades (Secondary)
  static const Color bluePrimary = Color(0xFF1DA1F2);
  static const Color blueDark = Color(0xFF0D8ECF);
  static const Color blueLight = Color(0xFF64C1FF);
  
  // Text & UI colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE3E3E3);
  static const Color textDisabled = Color(0xFF7D7D7D);
  
  // Accent colors
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color errorRed = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF43A047);
  
  // Transparent variants
  static Color bluePrimaryWithOpacity(double opacity) {
    return bluePrimary.withOpacity(opacity);
  }
  
  static Color blackPrimaryWithOpacity(double opacity) {
    return blackPrimary.withOpacity(opacity);
  }
  
  // Gradient
  static LinearGradient blueGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bluePrimary, blueDark],
  );
  
  static LinearGradient buttonGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [bluePrimary, blueDark],
  );
}