import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/theme/app_theme.dart';
import 'package:self_discipline_app/presentation/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
