import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const widgetText = Color(0xFFFF6F00);
  static const buttonBackground = Color(0xFF0B0B0B);
  static const background = Colors.black;
  static const angleControl = Colors.deepOrange;
  static const techGreen = Color(0xFF64DD17);
  static const techRed = Color(0xffff0022);
}

class AppTheme{
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBackground,
          textStyle: GoogleFonts.orbitron(
            color: AppColors.widgetText,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),

      textTheme: TextTheme(
        labelLarge: GoogleFonts.orbitron(
          color: AppColors.widgetText,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}