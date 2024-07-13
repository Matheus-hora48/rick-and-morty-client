import 'package:flutter/material.dart';

final class RickAndMortyTheme {
  static const primaryColor = Color(0xFF1da4b4);
  static const secundaryColor = Color(0xFF03535c);
  static const textColor = Color(0xFF444444);

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secundaryColor,
    ),
    useMaterial3: true,
    dividerColor: secundaryColor,
    textTheme: textTheme,
  );

  static const textTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: secundaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: secundaryColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: textColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
    ),
  );
}
