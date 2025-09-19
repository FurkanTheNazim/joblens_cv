import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/constants.dart';
import 'config/themes.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const JobLensCVApp());
}

class JobLensCVApp extends StatelessWidget {
  const JobLensCVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
