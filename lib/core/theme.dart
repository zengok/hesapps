import 'package:flutter/material.dart';

class AppTheme {
  // Kategori bazlı renk paleti
  static const Color indigo = Colors.indigo;
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Colors.amber;
  static const Color rose = Color(0xFFE11D48);

  // Koyu mod arka plan gradyanı (Derin lacivert - Siyah)
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF000000),
    ],
  );

  // Açık mod arka plan gradyanı (Yumuşak gri - Mavi)
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE2E8F0),
      Color(0xFFBFDBFE),
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: indigo,
      scaffoldBackgroundColor: Colors.transparent, // Scaffold uses transparent so gradient container behind can be seen
      fontFamily: 'Inter', // Google Fonts usage
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: indigo,
        secondary: emerald,
        error: rose,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: indigo,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Inter', // Google Fonts usage
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: indigo,
        secondary: emerald,
        error: rose,
      ),
    );
  }
}
