import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final cairoTextTheme = GoogleFonts.cairoTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppConstants.bgPureWhite,
      primaryColor: AppConstants.royalBluePrimary,
      colorScheme: ColorScheme.light(
        primary: AppConstants.royalBluePrimary,
        onPrimary: AppConstants.bgPureWhite,
        secondary: AppConstants.softGoldPrimary,
        onSecondary: AppConstants.royalBlueDark,
        surface: AppConstants.cardSurface,
        onSurface: AppConstants.textDark,
        background: AppConstants.bgPureWhite,
        error: Colors.redAccent,
      ),
      textTheme: cairoTextTheme.copyWith(
        displayLarge: cairoTextTheme.displayLarge?.copyWith(
          color: AppConstants.royalBlueDark,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: cairoTextTheme.titleLarge?.copyWith(
          color: AppConstants.royalBlueDark,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: cairoTextTheme.titleMedium?.copyWith(
          color: AppConstants.royalBluePrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: cairoTextTheme.bodyLarge?.copyWith(
          color: AppConstants.textDark,
        ),
        bodyMedium: cairoTextTheme.bodyMedium?.copyWith(
          color: AppConstants.textMuted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.royalBlueDark,
        foregroundColor: AppConstants.bgPureWhite,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppConstants.softGoldPrimary,
        ),
        iconTheme: const IconThemeData(color: AppConstants.softGoldPrimary),
      ),
      cardTheme: CardTheme(
        color: AppConstants.cardSurface,
        elevation: 3,
        shadowColor: AppConstants.royalBlueDark.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppConstants.softGoldPrimary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.royalBluePrimary,
          foregroundColor: AppConstants.bgPureWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.softGoldPrimary,
        foregroundColor: AppConstants.royalBlueDark,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dividerTheme: DividerThemeData(
        color: AppConstants.softGoldPrimary.withOpacity(0.3),
        thickness: 1,
        space: 24,
      ),
     dialogTheme: DialogThemeData(
        backgroundColor: AppConstants.bgPureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppConstants.softGoldPrimary, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.bgOffWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.royalBluePrimary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.royalBluePrimary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.softGoldPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.cairo(color: AppConstants.royalBluePrimary),
      ),
    );
  }
}
