import 'dart:math';
import '../models/user_profile.dart';
import '../models/job_posting.dart';
import '../../config/constants.dart';

class ATSService {
  // Calculate comprehensive ATS score
  static Map<String, dynamic> calculateATSScore(
    UserProfile profile,
    JobPosting? jobPosting,
  ) {
    final scoreData = <String, dynamic>{
      'totalScore': 0.0,
      'breakdown': <String, double>{},
      'recommendations': <String>[],
      'strengths': <String>[],
      'warnings': <String>[],
    };

    // 1. Profile Completeness (30%)
    final completenessScore = _calculateProfileCompleteness(profile);
    scoreData['breakdown']['completeness'] = completenessScore;

    // 2. Keyword Optimization (25%)
    final keywordScore = jobPosting != null 
        ? _calculateKeywordOptimization(profile, jobPosting)
        : 75.0; // Default score when no job posting
    scoreData['breakdown']['keywords'] = keywordScore;

    // 3. Content Quality (20%)
    final contentScore = _calculateContentQuality(profile);
    scoreData['breakdown']['content'] = contentScore;

    // 4. Format and Structure (15%)
    final formatScore = _calculateFormatScore(profile);
    scoreData['breakdown']['format'] = formatScore;

    // 5. Experience Relevance (10%)
    final experienceScore = _calculateExperienceRelevance(profile, jobPosting);
    scoreData['breakdown']['experience'] = experienceScore;

    // Calculate total score
    final totalScore = (completenessScore * 0.3) +
                      (keywordScore * 0.25) +
                      (contentScore * 0.2) +
                      (formatScore * 0.15) +
                      (experienceScore * 0.1);

    scoreData['totalScore'] = totalScore.clamp(0.0, 100.0);

    // Generate recommendations and insights
    _generateInsights(scoreData, profile, jobPosting);

    return scoreData;
  }

  // Calculate profile completeness score
  static double _calculateProfileCompleteness(UserProfile profile) {
    final completionCriteria = <String, bool>{
      'basicInfo': _hasBasicInfo(profile),
      'summary': profile.summary.isNotEmpty && profile.summary.length >= 50,
      'workExperience': profile.workExperience.isNotEmpty,
      'education': profile.education.isNotEmpty,
      'skills': profile.skills.length >= 5,
      'contactInfo': _hasCompleteContact(profile),
    };

    final completedCount = completionCriteria.values.where((completed) => completed).length;
    return (completedCount / completionCriteria.length) * 100;
  }

  static bool _hasBasicInfo(UserProfile profile) {
    return profile.fullName.isNotEmpty && profile.location.isNotEmpty;
  }

  static bool _hasCompleteContact(UserProfile profile) {
    return profile.email.isNotEmpty && 
           profile.phoneNumber.isNotEmpty &&
           profile.email.contains('@') &&
           profile.phoneNumber.length >= 10;
  }

  // Calculate keyword optimization score
  static double _calculateKeywordOptimization(UserProfile profile, JobPosting jobPosting) {
    final profileKeywords = _extractProfileKeywords(profile);
    final jobKeywords = _extractJobKeywords(jobPosting);
    
    if (jobKeywords.isEmpty) return 75.0;

    final matchingKeywords = profileKeywords
        .where((keyword) => jobKeywords.any((jobKeyword) => 
            jobKeyword.toLowerCase().contains(keyword.toLowerCase()) ||
            keyword.toLowerCase().contains(jobKeyword.toLowerCase())))
        .toList();

    final matchPercentage = (matchingKeywords.length / jobKeywords.length) * 100;
    
    // Boost score for critical skill matches
    double boostScore = 0.0;
    for (final requiredSkill in jobPosting.requiredSkills) {
      if (profileKeywords.any((keyword) => 
          keyword.toLowerCase().contains(requiredSkill.toLowerCase()))) {
        boostScore += 5.0; // 5 points per required skill match
      }
    }

    return (matchPercentage + boostScore).clamp(0.0, 100.0);
  }

  static List<String> _extractProfileKeywords(UserProfile profile) {
    final keywords = <String>[];
    
    // Skills
    keywords.addAll(profile.skills.map((skill) => skill.name));
    
    // Technologies from projects
    for (final project in profile.projects) {
      keywords.addAll(project.technologies);
    }
    
    // Languages
    keywords.addAll(profile.languages);
    
    // Certifications
    keywords.addAll(profile.certifications);
    
    // Extract from job titles and descriptions
    for (final experience in profile.workExperience) {
      keywords.add(experience.position);
      keywords.addAll(_extractKeywordsFromText(experience.description));
      keywords.addAll(experience.achievements.expand((achievement) => 
          _extractKeywordsFromText(achievement)));
    }
    
    return keywords.map((k) => k.trim()).where((k) => k.isNotEmpty).toList();
  }

  static List<String> _extractJobKeywords(JobPosting jobPosting) {
    final keywords = <String>[];
    
    keywords.addAll(jobPosting.requiredSkills);
    keywords.addAll(jobPosting.preferredSkills);
    keywords.addAll(jobPosting.responsibilities);
    keywords.addAll(jobPosting.qualifications);
    keywords.addAll(_extractKeywordsFromText(jobPosting.description));
    
    return keywords.map((k) => k.trim()).where((k) => k.isNotEmpty).toList();
  }

  static List<String> _extractKeywordsFromText(String text) {
    // Simple keyword extraction - in a real app, you might use NLP
    return text
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 3)
        .toList();
  }

  // Calculate content quality score
  static double _calculateContentQuality(UserProfile profile) {
    double score = 100.0;
    
    // Summary quality
    if (profile.summary.length < AppConstants.minSummaryLength) {
      score -= 20;
    } else if (profile.summary.length > AppConstants.maxSummaryLength) {
      score -= 10;
    }
    
    // Check for quantifiable achievements
    bool hasQuantifiableAchievements = false;
    for (final experience in profile.workExperience) {
      for (final achievement in experience.achievements) {
        if (RegExp(r'\d+%|\d+\$|\d+k|\d+ [a-zA-Z]').hasMatch(achievement)) {
          hasQuantifiableAchievements = true;
          break;
        }
      }
      if (hasQuantifiableAchievements) break;
    }
    
    if (!hasQuantifiableAchievements) {
      score -= 25;
    }
    
    // Check for action verbs
    final actionVerbCount = _countActionVerbs(profile);
    if (actionVerbCount < 3) {
      score -= 15;
    }
    
    return score.clamp(0.0, 100.0);
  }

  static int _countActionVerbs(UserProfile profile) {
    final actionVerbs = AppConstants.commonAtsKeywords['action_verbs']!;
    int count = 0;
    
    // Check summary
    for (final verb in actionVerbs) {
      if (profile.summary.toLowerCase().contains(verb.toLowerCase())) {
        count++;
      }
    }
    
    // Check experience descriptions and achievements
    for (final experience in profile.workExperience) {
      for (final verb in actionVerbs) {
        if (experience.description.toLowerCase().contains(verb.toLowerCase())) {
          count++;
        }
        for (final achievement in experience.achievements) {
          if (achievement.toLowerCase().contains(verb.toLowerCase())) {
            count++;
          }
        }
      }
    }
    
    return count;
  }

  // Calculate format score
  static double _calculateFormatScore(UserProfile profile) {
    double score = 100.0;
    
    // Name format
    if (!RegExp(r'^[a-zA-Z\s\-\']+$').hasMatch(profile.fullName)) {
      score -= 10;
    }
    
    // Email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(profile.email)) {
      score -= 15;
    }
    
    // Phone format
    final phoneDigits = profile.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (phoneDigits.length < 10) {
      score -= 10;
    }
    
    // Check for consistent date formatting
    // This would be more complex in a real implementation
    
    return score.clamp(0.0, 100.0);
  }

  // Calculate experience relevance score
  static double _calculateExperienceRelevance(UserProfile profile, JobPosting? jobPosting) {
    if (jobPosting == null || profile.workExperience.isEmpty) {
      return 75.0; // Default score
    }
    
    double relevanceScore = 0.0;
    
    // Check job title similarity
    for (final experience in profile.workExperience) {
      final titleSimilarity = _calculateStringSimilarity(
        experience.position.toLowerCase(),
        jobPosting.title.toLowerCase(),
      );
      relevanceScore += titleSimilarity * 40; // Max 40 points for title match
    }
    
    // Check industry relevance
    final companyTypes = profile.workExperience.map((exp) => exp.company).toList();
    // This would need more sophisticated industry classification
    
    return relevanceScore.clamp(0.0, 100.0);
  }

  static double _calculateStringSimilarity(String str1, String str2) {
    // Simple string similarity calculation
    final words1 = str1.split(' ').toSet();
    final words2 = str2.split(' ').toSet();
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return union > 0 ? intersection / union : 0.0;
  }

  // Generate insights and recommendations
  static void _generateInsights(
    Map<String, dynamic> scoreData,
    UserProfile profile,
    JobPosting? jobPosting,
  ) {
    final breakdown = scoreData['breakdown'] as Map<String, double>;
    final recommendations = scoreData['recommendations'] as List<String>;
    final strengths = scoreData['strengths'] as List<String>;
    final warnings = scoreData['warnings'] as List<String>;
    
    // Completeness insights
    if (breakdown['completeness']! < 80) {
      recommendations.add('Complete all profile sections for better ATS visibility');
      if (profile.summary.length < AppConstants.minSummaryLength) {
        recommendations.add('Expand your professional summary to at least ${AppConstants.minSummaryLength} characters');
      }
      if (profile.skills.length < 5) {
        recommendations.add('Add more relevant skills to increase keyword matching');
      }
    } else {
      strengths.add('Well-completed profile with all essential sections');
    }
    
    // Keyword insights
    if (breakdown['keywords']! < 70) {
      recommendations.add('Include more keywords that match your target job requirements');
      if (jobPosting != null) {
        recommendations.add('Review the job posting and incorporate relevant skills and technologies');
      }
    } else {
      strengths.add('Good keyword optimization for ATS systems');
    }
    
    // Content quality insights
    if (breakdown['content']! < 75) {
      recommendations.add('Add quantifiable achievements with specific numbers and metrics');
      recommendations.add('Use more action verbs to describe your accomplishments');
    } else {
      strengths.add('High-quality content with measurable achievements');
    }
    
    // Format insights
    if (breakdown['format']! < 85) {
      warnings.add('Check contact information format for ATS compatibility');
    } else {
      strengths.add('Professional formatting that ATS systems can easily parse');
    }
    
    // Overall score insights
    final totalScore = scoreData['totalScore'] as double;
    if (totalScore >= 85) {
      strengths.add('Excellent ATS optimization - your resume should perform well');
    } else if (totalScore >= 70) {
      recommendations.add('Good foundation, but some optimizations could improve your ATS score');
    } else {
      warnings.add('Significant improvements needed for better ATS compatibility');
    }
  }

  // Get ATS-friendly suggestions for content improvement
  static Map<String, List<String>> getContentSuggestions(UserProfile profile) {
    return {
      'actionVerbs': _suggestActionVerbs(profile),
      'quantifiableAchievements': _suggestQuantifiableAchievements(),
      'keywordOptimization': _suggestKeywordOptimization(profile),
      'formattingTips': _getFormattingTips(),
    };
  }

  static List<String> _suggestActionVerbs(UserProfile profile) {
    final usedVerbs = <String>[];
    final allContent = '${profile.summary} ${profile.workExperience.map((e) => '${e.description} ${e.achievements.join(' ')}')}';
    
    for (final verb in AppConstants.commonAtsKeywords['action_verbs']!) {
      if (allContent.toLowerCase().contains(verb.toLowerCase())) {
        usedVerbs.add(verb);
      }
    }
    
    return AppConstants.commonAtsKeywords['action_verbs']!
        .where((verb) => !usedVerbs.contains(verb))
        .take(10)
        .toList();
  }

  static List<String> _suggestQuantifiableAchievements() {
    return [
      'Include specific percentages (e.g., "Increased sales by 25%")',
      'Add dollar amounts or budget sizes',
      'Mention team sizes you managed',
      'Include timeframes for project completion',
      'Add customer satisfaction scores or ratings',
    ];
  }

  static List<String> _suggestKeywordOptimization(UserProfile profile) {
    return [
      'Research job postings in your field for common keywords',
      'Include technology names and versions',
      'Add industry-specific terminology',
      'Include soft skills mentioned in job requirements',
      'Use synonyms for important skills',
    ];
  }

  static List<String> _getFormattingTips() {
    return [
      'Use standard date formats (MM/YYYY)',
      'Avoid special characters in contact info',
      'Use consistent bullet points',
      'Keep job titles and company names clear',
      'Use professional email addresses',
    ];
  }

  // Analyze job posting and extract optimization suggestions
  static Map<String, dynamic> analyzeJobPosting(String jobDescription) {
    // This is a simplified implementation
    // In a real app, you'd use NLP/AI services
    
    final keywords = _extractKeywordsFromText(jobDescription);
    final requirements = _extractRequirements(jobDescription);
    final skillsNeeded = _extractSkills(jobDescription);
    
    return {
      'keywords': keywords.take(20).toList(),
      'requirements': requirements,
      'skills': skillsNeeded,
      'suggestions': _generateJobMatchSuggestions(keywords, requirements, skillsNeeded),
    };
  }

  static List<String> _extractRequirements(String jobDescription) {
    // Simple implementation - would be more sophisticated in real app
    final lines = jobDescription.split('\n');
    final requirements = <String>[];
    
    for (final line in lines) {
      if (line.toLowerCase().contains('require') || 
          line.toLowerCase().contains('must have') ||
          line.toLowerCase().contains('experience with')) {
        requirements.add(line.trim());
      }
    }
    
    return requirements;
  }

  static List<String> _extractSkills(String jobDescription) {
    final skills = <String>[];
    final commonSkills = [
      ...AppConstants.commonAtsKeywords['technical_skills']!,
      ...AppConstants.commonAtsKeywords['soft_skills']!,
    ];
    
    for (final skill in commonSkills) {
      if (jobDescription.toLowerCase().contains(skill.toLowerCase())) {
        skills.add(skill);
      }
    }
    
    return skills;
  }

  static List<String> _generateJobMatchSuggestions(
    List<String> keywords,
    List<String> requirements,
    List<String> skills,
  ) {
    return [
      'Include these key skills in your profile: ${skills.take(5).join(', ')}',
      'Use these important keywords: ${keywords.take(5).join(', ')}',
      'Highlight experience that matches the requirements',
      'Tailor your summary to address the main job responsibilities',
    ];
  }
}