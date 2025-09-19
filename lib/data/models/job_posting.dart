class JobPosting {
  final String id;
  final String title;
  final String company;
  final String description;
  final List<String> requiredSkills;
  final List<String> preferredSkills;
  final List<String> responsibilities;
  final List<String> qualifications;
  final Map<String, double> keywordWeights; // Anahtar kelimeler ve ağırlıkları

  JobPosting({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.requiredSkills,
    required this.preferredSkills,
    required this.responsibilities,
    required this.qualifications,
    required this.keywordWeights,
  });

  // İş ilanı URL'sinden veya açıklamasından oluşturulacak fabrika metodu
  // Bu metod, ileride AI/NLP servisi ile entegre edilecek
  factory JobPosting.fromUrl(String url) {
    // Şimdilik boş bir şablon döndürüyoruz
    // İleride burada API çağrısı yapılacak
    return JobPosting(
      id: 'temp_id',
      title: 'Extracted Job Title',
      company: 'Extracted Company',
      description: 'Extracted Description',
      requiredSkills: [],
      preferredSkills: [],
      responsibilities: [],
      qualifications: [],
      keywordWeights: {},
    );
  }

  factory JobPosting.fromDescription(String description) {
    // Şimdilik boş bir şablon döndürüyoruz
    // İleride burada NLP işlemi yapılacak
    return JobPosting(
      id: 'temp_id',
      title: 'Parsed Job Title',
      company: 'Parsed Company',
      description: description,
      requiredSkills: [],
      preferredSkills: [],
      responsibilities: [],
      qualifications: [],
      keywordWeights: {},
    );
  }

  // JSON dönüşüm metodları
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'description': description,
      'requiredSkills': requiredSkills,
      'preferredSkills': preferredSkills,
      'responsibilities': responsibilities,
      'qualifications': qualifications,
      'keywordWeights': keywordWeights,
    };
  }

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      description: json['description'],
      requiredSkills: List<String>.from(json['requiredSkills']),
      preferredSkills: List<String>.from(json['preferredSkills']),
      responsibilities: List<String>.from(json['responsibilities']),
      qualifications: List<String>.from(json['qualifications']),
      keywordWeights: Map<String, double>.from(json['keywordWeights']),
    );
  }
}