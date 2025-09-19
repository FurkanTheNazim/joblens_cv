import '../config/constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return 'Name must not exceed ${AppConstants.maxNameLength} characters';
    }
    
    // Check if name contains only letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Summary/Description validation
  static String? validateSummary(String? value) {
    if (value == null || value.isEmpty) {
      return 'Summary is required';
    }
    
    if (value.length < AppConstants.minSummaryLength) {
      return 'Summary must be at least ${AppConstants.minSummaryLength} characters';
    }
    
    if (value.length > AppConstants.maxSummaryLength) {
      return 'Summary must not exceed ${AppConstants.maxSummaryLength} characters';
    }
    
    return null;
  }
  
  // Experience description validation
  static String? validateExperienceDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Experience description is required';
    }
    
    if (value.length < AppConstants.minExperienceLength) {
      return 'Description must be at least ${AppConstants.minExperienceLength} characters';
    }
    
    if (value.length > AppConstants.maxExperienceLength) {
      return 'Description must not exceed ${AppConstants.maxExperienceLength} characters';
    }
    
    return null;
  }
  
  // Date validation
  static String? validateDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return '$fieldName cannot be in the future';
    }
    
    return null;
  }
  
  // Date range validation (start date must be before end date)
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return null; // Individual date validation handles null cases
    }
    
    if (startDate.isAfter(endDate)) {
      return 'Start date must be before end date';
    }
    
    return null;
  }
  
  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional in most cases
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL (must start with http:// or https://)';
    }
    
    return null;
  }
  
  // Skill level validation
  static String? validateSkillLevel(int? value) {
    if (value == null) {
      return 'Skill level is required';
    }
    
    if (value < 1 || value > 5) {
      return 'Skill level must be between 1 and 5';
    }
    
    return null;
  }
  
  // Company name validation
  static String? validateCompanyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    
    if (value.length < 2) {
      return 'Company name must be at least 2 characters';
    }
    
    if (value.length > 100) {
      return 'Company name must not exceed 100 characters';
    }
    
    return null;
  }
  
  // Job title validation
  static String? validateJobTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Job title is required';
    }
    
    if (value.length < 2) {
      return 'Job title must be at least 2 characters';
    }
    
    if (value.length > 100) {
      return 'Job title must not exceed 100 characters';
    }
    
    return null;
  }
  
  // Institution name validation
  static String? validateInstitution(String? value) {
    if (value == null || value.isEmpty) {
      return 'Institution name is required';
    }
    
    if (value.length < 2) {
      return 'Institution name must be at least 2 characters';
    }
    
    if (value.length > 150) {
      return 'Institution name must not exceed 150 characters';
    }
    
    return null;
  }
  
  // Degree validation
  static String? validateDegree(String? value) {
    if (value == null || value.isEmpty) {
      return 'Degree is required';
    }
    
    return null;
  }
  
  // Field of study validation
  static String? validateFieldOfStudy(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field of study is required';
    }
    
    if (value.length < 2) {
      return 'Field of study must be at least 2 characters';
    }
    
    if (value.length > 100) {
      return 'Field of study must not exceed 100 characters';
    }
    
    return null;
  }
  
  // Project title validation
  static String? validateProjectTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project title is required';
    }
    
    if (value.length < 3) {
      return 'Project title must be at least 3 characters';
    }
    
    if (value.length > 100) {
      return 'Project title must not exceed 100 characters';
    }
    
    return null;
  }
  
  // Location validation
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    
    if (value.length < 3) {
      return 'Location must be at least 3 characters';
    }
    
    if (value.length > 100) {
      return 'Location must not exceed 100 characters';
    }
    
    return null;
  }
  
  // List validation (for skills, technologies, etc.)
  static String? validateList(List<String>? list, String fieldName, {int minItems = 1}) {
    if (list == null || list.isEmpty) {
      if (minItems > 0) {
        return '$fieldName must have at least $minItems item(s)';
      }
      return null;
    }
    
    if (list.length < minItems) {
      return '$fieldName must have at least $minItems item(s)';
    }
    
    return null;
  }
  
  // ATS-friendly content validation
  static Map<String, dynamic> validateATSContent(String content) {
    final results = <String, dynamic>{
      'isATSFriendly': true,
      'score': 100.0,
      'warnings': <String>[],
      'suggestions': <String>[],
    };
    
    // Check for ATS-unfriendly elements
    if (content.contains(RegExp(r'[^\w\s\-.,;:()&@]'))) {
      results['warnings'].add('Contains special characters that may not be ATS-friendly');
      results['score'] -= 10;
    }
    
    // Check for action verbs
    final actionVerbCount = AppConstants.commonAtsKeywords['action_verbs']!
        .where((verb) => content.toLowerCase().contains(verb.toLowerCase()))
        .length;
    
    if (actionVerbCount < 2) {
      results['suggestions'].add('Consider adding more action verbs to improve ATS compatibility');
      results['score'] -= 5;
    }
    
    // Check length
    if (content.length < 50) {
      results['warnings'].add('Content may be too short for effective ATS parsing');
      results['score'] -= 15;
    }
    
    if (results['score'] < 70) {
      results['isATSFriendly'] = false;
    }
    
    return results;
  }
}

// Custom validation rules for specific use cases
class ATSValidators {
  // Validate keywords density
  static Map<String, dynamic> validateKeywordDensity(String content, List<String> targetKeywords) {
    final results = <String, dynamic>{
      'density': 0.0,
      'foundKeywords': <String>[],
      'missingKeywords': <String>[],
      'score': 0.0,
    };
    
    final words = content.toLowerCase().split(RegExp(r'\s+'));
    final totalWords = words.length;
    
    for (final keyword in targetKeywords) {
      final keywordLower = keyword.toLowerCase();
      if (content.toLowerCase().contains(keywordLower)) {
        results['foundKeywords'].add(keyword);
      } else {
        results['missingKeywords'].add(keyword);
      }
    }
    
    final foundCount = results['foundKeywords'].length;
    results['density'] = totalWords > 0 ? (foundCount / totalWords) * 100 : 0.0;
    results['score'] = (foundCount / targetKeywords.length) * 100;
    
    return results;
  }
  
  // Validate resume sections completeness
  static Map<String, dynamic> validateResumeCompleteness(Map<String, dynamic> profileData) {
    final results = <String, dynamic>{
      'completeness': 0.0,
      'missingSection': <String>[],
      'recommendations': <String>[],
    };
    
    final requiredSections = [
      'fullName',
      'email',
      'phoneNumber',
      'summary',
      'workExperience',
      'education',
      'skills'
    ];
    
    int completedSections = 0;
    
    for (final section in requiredSections) {
      if (profileData.containsKey(section) && profileData[section] != null) {
        if (profileData[section] is List && (profileData[section] as List).isNotEmpty) {
          completedSections++;
        } else if (profileData[section] is String && (profileData[section] as String).isNotEmpty) {
          completedSections++;
        }
      } else {
        results['missingSection'].add(section);
      }
    }
    
    results['completeness'] = (completedSections / requiredSections.length) * 100;
    
    // Add recommendations
    if (results['completeness'] < 100) {
      results['recommendations'].add('Complete all required sections for better ATS compatibility');
    }
    
    return results;
  }
}