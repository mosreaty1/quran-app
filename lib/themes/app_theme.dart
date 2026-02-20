import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Authentic Mushaf-style color palette and typography.
class MushafColors {
  // Parchment tones
  static const parchment = Color(0xFFF5EFD4);
  static const parchmentDark = Color(0xFFEDE5C0);
  static const parchmentDeep = Color(0xFFDDD0A0);

  // Gold accents
  static const gold = Color(0xFFC4922A);
  static const goldLight = Color(0xFFDAA643);
  static const goldDark = Color(0xFF9B7118);

  // Green (Islamic)
  static const green = Color(0xFF1B5E20);
  static const greenLight = Color(0xFF2E7D32);
  static const greenAccent = Color(0xFF4CAF50);

  // Text
  static const inkDark = Color(0xFF1A0A00);
  static const inkMedium = Color(0xFF3D2B1F);
  static const inkLight = Color(0xFF6B4C30);

  // Night mode
  static const nightBg = Color(0xFF0D0D0D);
  static const nightSurface = Color(0xFF1A1A1A);
  static const nightText = Color(0xFFE8D9B5);
  static const nightBorder = Color(0xFF3D3020);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: MushafColors.green,
        onPrimary: Colors.white,
        secondary: MushafColors.gold,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: MushafColors.parchment,
        onSurface: MushafColors.inkDark,
      ),
      scaffoldBackgroundColor: MushafColors.parchment,
      appBarTheme: const AppBarTheme(
        backgroundColor: MushafColors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: _buildTextTheme(MushafColors.inkDark),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: MushafColors.greenAccent,
        onPrimary: Colors.black,
        secondary: MushafColors.gold,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        surface: MushafColors.nightSurface,
        onSurface: MushafColors.nightText,
      ),
      scaffoldBackgroundColor: MushafColors.nightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: MushafColors.nightSurface,
        foregroundColor: MushafColors.nightText,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: _buildTextTheme(MushafColors.nightText),
      cardTheme: CardTheme(
        color: MushafColors.nightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: GoogleFonts.amiri(fontSize: 32, fontWeight: FontWeight.bold, color: baseColor),
      displayMedium: GoogleFonts.amiri(fontSize: 28, fontWeight: FontWeight.bold, color: baseColor),
      headlineLarge: GoogleFonts.amiri(fontSize: 24, fontWeight: FontWeight.bold, color: baseColor),
      headlineMedium: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.w600, color: baseColor),
      bodyLarge: GoogleFonts.amiri(fontSize: 18, color: baseColor),
      bodyMedium: GoogleFonts.amiri(fontSize: 16, color: baseColor),
      labelLarge: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      labelMedium: GoogleFonts.notoSans(fontSize: 12, color: baseColor),
    );
  }
}
