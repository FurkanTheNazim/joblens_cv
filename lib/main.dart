import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:joblens_cv/config/constants.dart';
import 'package:joblens_cv/config/themes.dart';
import 'package:joblens_cv/presentation/screens/onboarding/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Add more initialization here (Firebase, etc)
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Will be dynamic in the future
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      home: const SplashScreen(),
    );
  }
}