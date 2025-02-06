import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color(0xFF416BD6),
      secondary: Color(0xFF6D6265),
      tertiary: Color(0xFF231F20),
      inversePrimary: Color(0xFFFFFFFF),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF231F20),
      secondary: Color(0xFF6D6265),
      tertiary: Color(0xFF416BD6),
      inversePrimary: Colors.white,
    ),
  );
}
