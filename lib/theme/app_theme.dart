import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color tokens
  static const Color indigo = Color(0xFF6200EE);
  static const Color emerald = Color(0xFF50C878);
  static const Color purple = Color(0xFFB39DDB);
  static const Color amber = Colors.amber;
  static const Color rose = Color(0xFFE11D48);
  static const Color darkNavy = Color(0xFF0F172A); // Light mode text color

  // Dark: Glassmorphism 2.0 Cosmic Void
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B0E11), Color(0xFF1A1A2E)],
  );

  // Light: Soft grey-blue glassmorphism (açık mod)
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: indigo,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: darkNavy,
        displayColor: darkNavy,
      ),
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: indigo,
        secondary: emerald,
        error: rose,
        onSurface: darkNavy,
        surface: Color(0xFFF8FAFC),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? emerald : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Color(0x6650C878) // emerald ~40%
              : Color(0x4D9E9E9E), // grey ~30%
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: indigo,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: indigo,
        secondary: emerald,
        error: rose,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? emerald : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Color(0x6650C878)
              : Color(0x4D9E9E9E),
        ),
      ),
    );
  }
}
