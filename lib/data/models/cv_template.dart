class CVTemplate {
  final String id;
  final String name;
  final String description;
  final String thumbnail; // Thumbnail için asset yolu
  final bool isPremium;
  final Map<String, dynamic> layoutSettings;
  final Map<String, dynamic> styleSettings;

  CVTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    this.isPremium = false,
    required this.layoutSettings,
    required this.styleSettings,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
      'isPremium': isPremium,
      'layoutSettings': layoutSettings,
      'styleSettings': styleSettings,
    };
  }

  factory CVTemplate.fromJson(Map<String, dynamic> json) {
    return CVTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      isPremium: json['isPremium'] ?? false,
      layoutSettings: json['layoutSettings'],
      styleSettings: json['styleSettings'],
    );
  }
}

// CV çıktısı modeli
class OptimizedCV {
  final String id;
  final UserProfile userProfile; // İçe aktarma gerekecek
  final JobPosting jobPosting; // İçe aktarma gerekecek
  final CVTemplate template;
  final double atsScore; // ATS puanı (0-100)
  final Map<String, String> optimizedSections; // Optimize edilmiş içerik
  final DateTime createdAt;

  OptimizedCV({
    required this.id,
    required this.userProfile,
    required this.jobPosting,
    required this.template,
    required this.atsScore,
    required this.optimizedSections,
    required this.createdAt,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userProfile': userProfile.toJson(),
      'jobPosting': jobPosting.toJson(),
      'template': template.toJson(),
      'atsScore': atsScore,
      'optimizedSections': optimizedSections,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OptimizedCV.fromJson(Map<String, dynamic> json) {
    return OptimizedCV(
      id: json['id'],
      userProfile: UserProfile.fromJson(json['userProfile']),
      jobPosting: JobPosting.fromJson(json['jobPosting']),
      template: CVTemplate.fromJson(json['template']),
      atsScore: json['atsScore'],
      optimizedSections: Map<String, String>.from(json['optimizedSections']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}