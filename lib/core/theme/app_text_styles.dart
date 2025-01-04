import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';

class AppTextStyles {
  static final TextTheme lightTheme = GoogleFonts.interTextTheme(
    TextTheme(
      displayLarge: headline1.copyWith(color: AppColors.textPrimaryLight),
      displayMedium: headline2.copyWith(color: AppColors.textPrimaryLight),
      displaySmall: headline3.copyWith(color: AppColors.textPrimaryLight),
      headlineLarge: headline4.copyWith(color: AppColors.textPrimaryLight),
      headlineMedium: headline5.copyWith(color: AppColors.textPrimaryLight),
      headlineSmall: headline6.copyWith(color: AppColors.textPrimaryLight),
      titleLarge: title.copyWith(color: AppColors.textPrimaryLight),
      bodyLarge: body1.copyWith(color: AppColors.textPrimaryLight),
      bodyMedium: body2.copyWith(color: AppColors.textSecondaryLight),
      labelLarge: button.copyWith(color: AppColors.textPrimaryLight),
      bodySmall: caption.copyWith(color: AppColors.textSecondaryLight),
    ),
  );

  static final TextTheme darkTheme = GoogleFonts.interTextTheme(
    TextTheme(
      displayLarge: headline1.copyWith(color: AppColors.textPrimaryDark),
      displayMedium: headline2.copyWith(color: AppColors.textPrimaryDark),
      displaySmall: headline3.copyWith(color: AppColors.textPrimaryDark),
      headlineLarge: headline4.copyWith(color: AppColors.textPrimaryDark),
      headlineMedium: headline5.copyWith(color: AppColors.textPrimaryDark),
      headlineSmall: headline6.copyWith(color: AppColors.textPrimaryDark),
      titleLarge: title.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: body1.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: body2.copyWith(color: AppColors.textSecondaryDark),
      labelLarge: button.copyWith(color: AppColors.textPrimaryDark),
      bodySmall: caption.copyWith(color: AppColors.textSecondaryDark),
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

  static const TextStyle headline3 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const TextStyle headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle headline6 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
}
