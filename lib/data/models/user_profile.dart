class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String location;
  final String summary;
  final List<Education> education;
  final List<Experience> workExperience;
  final List<Skill> skills;
  final List<Project> projects;
  final List<String> languages;
  final List<String> certifications;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.summary,
    required this.education,
    required this.workExperience,
    required this.skills,
    required this.projects,
    required this.languages,
    required this.certifications,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'summary': summary,
      'education': education.map((e) => e.toJson()).toList(),
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'languages': languages,
      'certifications': certifications,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      summary: json['summary'],
      education: (json['education'] as List)
          .map((e) => Education.fromJson(e))
          .toList(),
      workExperience: (json['workExperience'] as List)
          .map((e) => Experience.fromJson(e))
          .toList(),
      skills: (json['skills'] as List).map((e) => Skill.fromJson(e)).toList(),
      projects: (json['projects'] as List)
          .map((e) => Project.fromJson(e))
          .toList(),
      languages: List<String>.from(json['languages']),
      certifications: List<String>.from(json['certifications']),
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrently;
  final String description;

  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    required this.isCurrently,
    required this.description,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrently': isCurrently,
      'description': description,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'],
      degree: json['degree'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrently: json['isCurrently'],
      description: json['description'],
    );
  }
}

class Experience {
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrently;
  final String description;
  final List<String> achievements;

  Experience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.isCurrently,
    required this.description,
    required this.achievements,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrently': isCurrently,
      'description': description,
      'achievements': achievements,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'],
      position: json['position'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrently: json['isCurrently'],
      description: json['description'],
      achievements: List<String>.from(json['achievements']),
    );
  }
}

class Skill {
  final String name;
  final int level; // 1-5 arası yetkinlik seviyesi
  final String category; // Teknik, Kişisel, vb.

  Skill({
    required this.name,
    required this.level,
    required this.category,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      level: json['level'],
      category: json['category'],
    );
  }
}

class Project {
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? url;
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.url,
    required this.technologies,
  });

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'url': url,
      'technologies': technologies,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      url: json['url'],
      technologies: List<String>.from(json['technologies']),
    );
  }
}