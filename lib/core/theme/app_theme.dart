import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:self_discipline_app/core/theme/app_text_styles.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppSecondaryColors.liquidLava,
      scaffoldBackgroundColor:  Colors.grey.shade200,
      textTheme: AppTextStyles.lightTheme,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppSecondaryColors.snow,
        foregroundColor: AppSecondaryColors.darkVoid,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppSecondaryColors.darkVoid,
        ),
      ),

      // Bottom Navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppSecondaryColors.snow,
        selectedItemColor: AppSecondaryColors.liquidLava,
        unselectedItemColor: AppSecondaryColors.dustyGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppSecondaryColors.liquidLava,
        foregroundColor: AppSecondaryColors.snow,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppSecondaryColors.snow,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppSecondaryColors.snow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppSecondaryColors.slateGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppSecondaryColors.slateGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppSecondaryColors.liquidLava, width: 2),
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppSecondaryColors.liquidLava,
          foregroundColor: AppSecondaryColors.snow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      colorScheme: ColorScheme.light(
        primary: AppSecondaryColors.liquidLava,
        secondary: AppSecondaryColors.liquidLava,
        surface: AppSecondaryColors.snow,
        background: AppSecondaryColors.snow,
        error: Colors.red,
        onPrimary: AppSecondaryColors.snow,
        onSecondary: AppSecondaryColors.snow,
        onSurface: AppSecondaryColors.darkVoid,
        onBackground: AppSecondaryColors.darkVoid,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppSecondaryColors.liquidLava,
      scaffoldBackgroundColor: AppSecondaryColors.darkVoid,
      textTheme: AppTextStyles.darkTheme,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppSecondaryColors.darkVoid,
        foregroundColor: AppSecondaryColors.snow,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppSecondaryColors.snow,
        ),
      ),

      // Bottom Navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppSecondaryColors.gluonGrey,
        selectedItemColor: AppSecondaryColors.liquidLava,
        unselectedItemColor: AppSecondaryColors.dustyGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppSecondaryColors.liquidLava,
        foregroundColor: AppSecondaryColors.snow,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppSecondaryColors.gluonGrey,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppSecondaryColors.gluonGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppSecondaryColors.slateGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppSecondaryColors.slateGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppSecondaryColors.liquidLava, width: 2),
        ),
        labelStyle: TextStyle(color: AppSecondaryColors.dustyGrey),
        hintStyle: TextStyle(color: AppSecondaryColors.dustyGrey),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppSecondaryColors.liquidLava,
          foregroundColor: AppSecondaryColors.snow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppSecondaryColors.gluonGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppSecondaryColors.slateGrey,
        thickness: 1,
      ),

      colorScheme: ColorScheme.dark(
        primary: AppSecondaryColors.liquidLava,
        secondary: AppSecondaryColors.liquidLava,
        surface: AppSecondaryColors.gluonGrey,
        background: AppSecondaryColors.darkVoid,
        error: AppColors.errorDark,
        onPrimary: AppSecondaryColors.snow,
        onSecondary: AppSecondaryColors.snow,
        onSurface: AppSecondaryColors.snow,
        onBackground: AppSecondaryColors.snow,
        onError: AppSecondaryColors.snow,
      ),
    );
  }
}
