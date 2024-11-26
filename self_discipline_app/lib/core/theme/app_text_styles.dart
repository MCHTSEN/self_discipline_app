import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextTheme lightTheme = GoogleFonts.kanitTextTheme(
    TextTheme(
      displayLarge: headline1.copyWith(color: Colors.black),
      displayMedium: headline2.copyWith(color: Colors.black),
      bodyLarge: body1.copyWith(color: Colors.black),
      labelLarge: button.copyWith(color: Colors.black),
    ),
  );

  static final TextTheme darkTheme = GoogleFonts.kanitTextTheme(
    TextTheme(
      displayLarge: headline1.copyWith(color: Colors.white),
      displayMedium: headline2.copyWith(color: Colors.white),
      bodyLarge: body1.copyWith(color: Colors.white),
      labelLarge: button.copyWith(color: Colors.white),
    ),
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );
}
