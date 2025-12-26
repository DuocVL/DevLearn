import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Brand colors
  static const Color _brandBlue = Color(0xFF0B72FF);
  static const Color _brandIndigo = Color(0xFF243BFF);
  static const Color _brandAmber = Color(0xFFFFA726);

  static const double _radiusSm = 8.0;
  static const double _radiusMd = 12.0;
  static const double _radiusLg = 16.0;

  // 🌞 LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _brandBlue,
      secondary: _brandAmber,
      surface: Colors.white,
      background: Color(0xFFF6F9FF),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F9FF),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: _brandBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
    ),

    // Typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),

    // Icons
    iconTheme: const IconThemeData(color: Colors.black54),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _brandBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusMd)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _brandBlue,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
        side: const BorderSide(color: _brandBlue, width: 1.2),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _brandBlue, textStyle: const TextStyle(fontWeight: FontWeight.w600)),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _brandIndigo, width: 2),
        borderRadius: BorderRadius.circular(_radiusSm),
      ),
      labelStyle: const TextStyle(color: Colors.black54),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusLg)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    ),

    // App-wide components
    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusMd))),
    chipTheme: ChipThemeData(backgroundColor: _brandBlue.withOpacity(0.12), labelStyle: const TextStyle(color: _brandBlue)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: _brandBlue, foregroundColor: Colors.white),
    dividerTheme: const DividerThemeData(color: Color(0xFFE8EEF8), thickness: 1),

    // Bottom nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _brandIndigo,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // 🌙 DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1DBAB6),
      secondary: Color(0xFFFFB74D),
      surface: Color(0xFF121212),
      background: Color(0xFF0D0D0D),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF0B0B0B),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B0B0B),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),

    iconTheme: const IconThemeData(color: Colors.white70),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1DBAB6),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusMd)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white70,
        side: BorderSide(color: Colors.white12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusSm)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.white70)),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(_radiusSm), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF1DBAB6), width: 2),
        borderRadius: BorderRadius.circular(_radiusSm),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF141414),
      elevation: 6,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusLg)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    ),

    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radiusMd))),
    chipTheme: ChipThemeData(backgroundColor: Colors.white10, labelStyle: const TextStyle(color: Colors.white70)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color(0xFF1DBAB6), foregroundColor: Colors.black),
    dividerTheme: const DividerThemeData(color: Color(0xFF262626), thickness: 1),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF1DBAB6),
      unselectedItemColor: Colors.white54,
      backgroundColor: Color(0xFF0D0D0D),
      type: BottomNavigationBarType.fixed,
    ),
  );
}

