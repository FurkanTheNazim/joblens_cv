class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.joblens.dev';
  
  // App Info
  static const String appName = 'JobLensCV';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String savedCVsKey = 'saved_cvs';
  static const String themeKey = 'app_theme';
  
  // Feature Flags
  static const bool enableAIFeatures = true;
  static const bool enablePremiumFeatures = false; // Beta'da premium özellikler kapalı
  
  // Limits
  static const int maxFreeTemplates = 3;
  static const int maxFreeCVsPerMonth = 5;
}