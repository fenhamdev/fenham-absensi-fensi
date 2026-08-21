import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Light Mode Color Palette ───────────────────────────────────────────────
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

  // ─── Dark Mode Color Palette ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkNavy = Color(0xFF3B82F6);

  // ─── Light Theme ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: softBackground,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: primaryNavy,
        primary: primaryNavy,
        secondary: emeraldGreen,
        surface: Colors.white,
        onSurface: slateGray,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(color: slateGray, fontWeight: FontWeight.bold, fontSize: 32),
        titleLarge: const TextStyle(color: slateGray, fontWeight: FontWeight.bold, fontSize: 20),
        titleMedium: const TextStyle(color: slateGray, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: const TextStyle(color: slateGray, fontSize: 16),
        bodyMedium: const TextStyle(color: slateGray, fontSize: 14),
        bodySmall: const TextStyle(color: textMuted, fontSize: 12),
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

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: darkNavy,
        primary: darkNavy,
        secondary: emeraldGreen,
        surface: darkSurface,
        onSurface: darkTextPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold, fontSize: 32),
        titleLarge: const TextStyle(color: darkTextPrimary, fontWeight: FontWeight.bold, fontSize: 20),
        titleMedium: const TextStyle(color: darkTextPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: const TextStyle(color: darkTextPrimary, fontSize: 16),
        bodyMedium: const TextStyle(color: darkTextPrimary, fontSize: 14),
        bodySmall: const TextStyle(color: darkTextMuted, fontSize: 12),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: darkTextMuted),
        labelStyle: const TextStyle(color: darkTextMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkNavy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: roseDanger),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkNavy,
        unselectedItemColor: darkTextMuted,
      ),
    );
  }
}
