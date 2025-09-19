import 'dart:math';
import 'package:flutter/material.dart';
import '../config/constants.dart';

class Helpers {
  // Date formatting
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  static String formatDateFull(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
  
  static String formatDateRange(DateTime startDate, DateTime? endDate, bool isCurrently) {
    final start = formatDateFull(startDate);
    if (isCurrently) {
      return '$start - Present';
    }
    final end = formatDateFull(endDate);
    return '$start - $end';
  }
  
  // Calculate duration between dates
  static String calculateDuration(DateTime startDate, DateTime? endDate, bool isCurrently) {
    final end = isCurrently ? DateTime.now() : endDate ?? DateTime.now();
    final difference = end.difference(startDate);
    
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    
    if (years > 0 && months > 0) {
      return '$years yr ${months} mo';
    } else if (years > 0) {
      return '$years yr';
    } else if (months > 0) {
      return '$months mo';
    } else {
      return '< 1 mo';
    }
  }
  
  // Text utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }
  
  // Phone number formatting
  static String formatPhoneNumber(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    }
    
    return phoneNumber; // Return original if can't format
  }
  
  // Color utilities
  static Color getSkillLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.red.shade300;
      case 2:
        return Colors.orange.shade300;
      case 3:
        return Colors.yellow.shade600;
      case 4:
        return Colors.lightGreen.shade400;
      case 5:
        return Colors.green.shade600;
      default:
        return Colors.grey.shade400;
    }
  }
  
  static Color getATSScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
  
  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }
  
  // Validate and clean text for ATS
  static String cleanTextForATS(String text) {
    // Remove special characters that ATS might not handle well
    return text
        .replaceAll(RegExp(r'[^\w\s\-.,;:()&@]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
  
  // Extract keywords from text
  static List<String> extractKeywords(String text) {
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2)
        .toSet()
        .toList();
    
    return words;
  }
  
  // Calculate keyword match percentage
  static double calculateKeywordMatch(List<String> resumeKeywords, List<String> jobKeywords) {
    if (jobKeywords.isEmpty) return 0.0;
    
    final resumeSet = resumeKeywords.map((k) => k.toLowerCase()).toSet();
    final jobSet = jobKeywords.map((k) => k.toLowerCase()).toSet();
    
    final intersection = resumeSet.intersection(jobSet).length;
    return (intersection / jobSet.length) * 100;
  }
  
  // ATS Score Calculation
  static Map<String, dynamic> calculateATSScore(
    Map<String, dynamic> profileData,
    Map<String, dynamic>? jobData,
  ) {
    double totalScore = 0.0;
    final breakdown = <String, double>{};
    
    // Basic completeness score (40%)
    final completenessScore = _calculateCompletenessScore(profileData);
    breakdown['completeness'] = completenessScore;
    totalScore += completenessScore * 0.4;
    
    // Keyword matching score (35%) - only if job data is provided
    double keywordScore = 0.0;
    if (jobData != null) {
      keywordScore = _calculateKeywordScore(profileData, jobData);
      breakdown['keywords'] = keywordScore;
      totalScore += keywordScore * 0.35;
    } else {
      totalScore += 75.0 * 0.35; // Default score when no job data
    }
    
    // Format and structure score (25%)
    final formatScore = _calculateFormatScore(profileData);
    breakdown['format'] = formatScore;
    totalScore += formatScore * 0.25;
    
    return {
      'totalScore': totalScore.clamp(0.0, 100.0),
      'breakdown': breakdown,
      'recommendations': _generateRecommendations(breakdown, totalScore),
    };
  }
  
  static double _calculateCompletenessScore(Map<String, dynamic> profileData) {
    final requiredFields = [
      'fullName', 'email', 'phoneNumber', 'location', 'summary',
      'workExperience', 'education', 'skills'
    ];
    
    int completedFields = 0;
    
    for (final field in requiredFields) {
      if (profileData.containsKey(field) && profileData[field] != null) {
        if (profileData[field] is List) {
          if ((profileData[field] as List).isNotEmpty) completedFields++;
        } else if (profileData[field] is String) {
          if ((profileData[field] as String).isNotEmpty) completedFields++;
        } else {
          completedFields++;
        }
      }
    }
    
    return (completedFields / requiredFields.length) * 100;
  }
  
  static double _calculateKeywordScore(
    Map<String, dynamic> profileData,
    Map<String, dynamic> jobData,
  ) {
    // Extract keywords from job posting
    final jobKeywords = <String>[];
    if (jobData['requiredSkills'] != null) {
      jobKeywords.addAll(List<String>.from(jobData['requiredSkills']));
    }
    if (jobData['preferredSkills'] != null) {
      jobKeywords.addAll(List<String>.from(jobData['preferredSkills']));
    }
    
    // Extract keywords from profile
    final profileKeywords = <String>[];
    if (profileData['skills'] != null) {
      final skills = profileData['skills'] as List;
      for (final skill in skills) {
        if (skill is Map && skill['name'] != null) {
          profileKeywords.add(skill['name']);
        }
      }
    }
    
    return calculateKeywordMatch(profileKeywords, jobKeywords);
  }
  
  static double _calculateFormatScore(Map<String, dynamic> profileData) {
    double score = 100.0;
    
    // Check summary length
    if (profileData['summary'] != null) {
      final summaryLength = (profileData['summary'] as String).length;
      if (summaryLength < AppConstants.minSummaryLength) {
        score -= 15;
      } else if (summaryLength > AppConstants.maxSummaryLength) {
        score -= 10;
      }
    }
    
    // Check for quantifiable achievements in experience
    if (profileData['workExperience'] != null) {
      final experiences = profileData['workExperience'] as List;
      bool hasQuantifiableAchievements = false;
      
      for (final exp in experiences) {
        if (exp is Map && exp['achievements'] != null) {
          final achievements = exp['achievements'] as List;
          for (final achievement in achievements) {
            if (achievement.toString().contains(RegExp(r'\d+'))) {
              hasQuantifiableAchievements = true;
              break;
            }
          }
        }
        if (hasQuantifiableAchievements) break;
      }
      
      if (!hasQuantifiableAchievements) {
        score -= 20;
      }
    }
    
    return score.clamp(0.0, 100.0);
  }
  
  static List<String> _generateRecommendations(
    Map<String, double> breakdown,
    double totalScore,
  ) {
    final recommendations = <String>[];
    
    if (breakdown['completeness']! < 80) {
      recommendations.add('Complete all profile sections for better ATS compatibility');
    }
    
    if (breakdown['keywords']! < 70) {
      recommendations.add('Add more relevant keywords that match the job requirements');
    }
    
    if (breakdown['format']! < 80) {
      recommendations.add('Include quantifiable achievements and optimize content length');
    }
    
    if (totalScore < 70) {
      recommendations.add('Consider reviewing and optimizing your profile for better ATS scoring');
    }
    
    return recommendations;
  }
  
  // Utility to check if a string contains any of the target keywords
  static bool containsKeywords(String text, List<String> keywords) {
    final textLower = text.toLowerCase();
    return keywords.any((keyword) => textLower.contains(keyword.toLowerCase()));
  }
  
  // Generate professional email suggestions
  static List<String> generateEmailSuggestions(String fullName) {
    final names = fullName.toLowerCase().split(' ');
    if (names.length < 2) return [];
    
    final firstName = names.first;
    final lastName = names.last;
    
    return [
      '$firstName.$lastName@gmail.com',
      '$firstName$lastName@gmail.com',
      '${firstName[0]}$lastName@gmail.com',
      '$firstName.${lastName[0]}@gmail.com',
    ];
  }
  
  // Show loading dialog
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
  
  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  // Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}