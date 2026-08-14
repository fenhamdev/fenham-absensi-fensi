import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette Definitions
  static const Color slateGray = Color(0xFF0F172A);
  static const Color slateDark = Color(0xFF1E293B);
  static const Color softBackground = Color(0xFFF8FAFC);
  static const Color primaryNavy = Color(0xFF1E3A8A);
  static const Color primaryNavyLight = Color(0xFF3B82F6);
  static const Color emeraldGreen = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFFD1FAE5);
  static const Color amberWarning = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color roseDanger = Color(0xFFDC2626);
  static const Color roseLight = Color(0xFFFEE2E2);
  static const Color neutralBorder = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: softBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryNavy,
        primary: primaryNavy,
        secondary: emeraldGreen,
        background: softBackground,
        surface: Colors.white,
        onSurface: slateGray,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: TextStyle(color: slateGray, fontWeight: FontWeight.bold, fontSize: 32),
        titleLarge: TextStyle(color: slateGray, fontWeight: FontWeight.bold, fontSize: 20),
        titleMedium: TextStyle(color: slateGray, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(color: slateGray, fontSize: 16),
        bodyMedium: TextStyle(color: slateGray, fontSize: 14),
        bodySmall: TextStyle(color: textMuted, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: neutralBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: slateGray),
        titleTextStyle: TextStyle(
          color: slateGray,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neutralBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neutralBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryNavy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: roseDanger),
        ),
      ),
    );
  }
}
