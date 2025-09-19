class AppConstants {
  // App Info
  static const String appName = 'JobLensCV';
  static const String appVersion = '1.0.0';
  
  // Colors (ATS-friendly color palette)
  static const int primaryColor = 0xFF2C3E50;
  static const int secondaryColor = 0xFF3498DB;
  static const int accentColor = 0xFF1ABC9C;
  static const int backgroundColor = 0xFFF8F9FA;
  static const int textColor = 0xFF2C3E50;
  static const int lightGrayColor = 0xFFECF0F1;
  static const int darkGrayColor = 0xFF95A5A6;
  
  // Typography (ATS-friendly fonts)
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Open Sans';
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  
  // Form Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minSummaryLength = 50;
  static const int maxSummaryLength = 500;
  static const int minExperienceLength = 20;
  static const int maxExperienceLength = 1000;
  
  // ATS Keywords Weight Categories
  static const Map<String, double> atsKeywordWeights = {
    'technical_skills': 0.25,
    'soft_skills': 0.15,
    'experience_keywords': 0.20,
    'education_keywords': 0.15,
    'job_title_match': 0.25,
  };
  
  // Common ATS-friendly keywords by category
  static const Map<String, List<String>> commonAtsKeywords = {
    'technical_skills': [
      'Programming', 'Software Development', 'Web Development', 'Mobile Development',
      'Database', 'API', 'Cloud Computing', 'DevOps', 'Agile', 'Scrum',
      'Machine Learning', 'AI', 'Data Analysis', 'Project Management'
    ],
    'soft_skills': [
      'Communication', 'Leadership', 'Team Work', 'Problem Solving',
      'Critical Thinking', 'Creativity', 'Adaptability', 'Time Management',
      'Collaboration', 'Innovation', 'Customer Service', 'Analytical'
    ],
    'action_verbs': [
      'Achieved', 'Developed', 'Implemented', 'Managed', 'Led', 'Created',
      'Improved', 'Optimized', 'Designed', 'Coordinated', 'Delivered',
      'Increased', 'Reduced', 'Enhanced', 'Established', 'Streamlined'
    ]
  };
  
  // CV Template Categories
  static const List<String> cvTemplateCategories = [
    'Professional',
    'Creative',
    'Academic',
    'Technical',
    'Executive',
    'Entry Level'
  ];
  
  // Skill Level Definitions
  static const Map<int, String> skillLevels = {
    1: 'Beginner',
    2: 'Basic',
    3: 'Intermediate',
    4: 'Advanced',
    5: 'Expert'
  };
  
  // Education Degree Types
  static const List<String> degreeTypes = [
    'High School Diploma',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctoral Degree',
    'Professional Certification',
    'Bootcamp Certificate',
    'Online Course Certificate'
  ];
  
  // Experience Level Categories
  static const List<String> experienceLevels = [
    'Entry Level (0-2 years)',
    'Mid Level (3-5 years)',
    'Senior Level (6-10 years)',
    'Lead Level (11-15 years)',
    'Executive Level (15+ years)'
  ];
  
  // API Endpoints (for future integrations)
  static const String baseApiUrl = 'https://api.joblensCV.com/v1';
  static const String aiAnalysisEndpoint = '/ai/analyze';
  static const String jobPostingParseEndpoint = '/jobs/parse';
  static const String atsScoreEndpoint = '/ats/score';
  
  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String cvTemplatesKey = 'cv_templates';
  static const String savedCVsKey = 'saved_cvs';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String appSettingsKey = 'app_settings';
}