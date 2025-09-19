import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/ats_service.dart';
import '../../config/constants.dart';
import '../../config/themes.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import 'education_input_screen.dart';
import 'experience_input_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Basic Info Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _summaryController = TextEditingController();
  
  // Profile Data
  List<Education> _educationList = [];
  List<Experience> _experienceList = [];
  List<Skill> _skillsList = [];
  List<Project> _projectsList = [];
  List<String> _languages = [];
  List<String> _certifications = [];
  
  // ATS Score Data
  Map<String, dynamic>? _atsScoreData;
  bool _isCalculatingScore = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    // In a real app, this would load from storage/database
    // For now, we'll start with empty data
  }

  void _calculateATSScore() {
    setState(() {
      _isCalculatingScore = true;
    });

    // Simulate calculation delay
    Future.delayed(const Duration(seconds: 1), () {
      final profile = _createUserProfile();
      final scoreData = ATSService.calculateATSScore(profile, null);
      
      setState(() {
        _atsScoreData = scoreData;
        _isCalculatingScore = false;
      });
    });
  }

  UserProfile _createUserProfile() {
    return UserProfile(
      id: Helpers.generateId(),
      fullName: _fullNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      summary: _summaryController.text,
      education: _educationList,
      workExperience: _experienceList,
      skills: _skillsList,
      projects: _projectsList,
      languages: _languages,
      certifications: _certifications,
    );
  }

  void _addEducation(Education education) {
    setState(() {
      _educationList.add(education);
    });
    _calculateATSScore();
  }

  void _editEducation(int index, Education education) {
    setState(() {
      _educationList[index] = education;
    });
    _calculateATSScore();
  }

  void _removeEducation(int index) {
    setState(() {
      _educationList.removeAt(index);
    });
    _calculateATSScore();
  }

  void _addExperience(Experience experience) {
    setState(() {
      _experienceList.add(experience);
    });
    _calculateATSScore();
  }

  void _editExperience(int index, Experience experience) {
    setState(() {
      _experienceList[index] = experience;
    });
    _calculateATSScore();
  }

  void _removeExperience(int index) {
    setState(() {
      _experienceList.removeAt(index);
    });
    _calculateATSScore();
  }

  void _showEducationForm({Education? education, int? index}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EducationInputScreen(
          education: education,
          onSave: (newEducation) {
            if (index != null) {
              _editEducation(index, newEducation);
            } else {
              _addEducation(newEducation);
            }
          },
        ),
      ),
    );
  }

  void _showExperienceForm({Experience? experience, int? index}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExperienceInputScreen(
          experience: experience,
          onSave: (newExperience) {
            if (index != null) {
              _editExperience(index, newExperience);
            } else {
              _addExperience(newExperience);
            }
          },
        ),
      ),
    );
  }

  Widget _buildATSScoreCard() {
    if (_atsScoreData == null && !_isCalculatingScore) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48,
                color: Color(AppConstants.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'ATS Score Analysis',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Add your profile information to get your ATS compatibility score',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateATSScore,
                child: const Text('Calculate ATS Score'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isCalculatingScore) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Calculating ATS Score...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    final totalScore = _atsScoreData!['totalScore'] as double;
    final breakdown = _atsScoreData!['breakdown'] as Map<String, double>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: JobLensColors.getATSScoreColor(totalScore),
                  ),
                  child: Center(
                    child: Text(
                      '${totalScore.round()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ATS Compatibility Score',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        _getScoreDescription(totalScore),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: JobLensColors.getATSScoreColor(totalScore),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _calculateATSScore,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Recalculate',
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...breakdown.entries.map((entry) => _buildScoreBreakdownItem(
              _getBreakdownLabel(entry.key),
              entry.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBreakdownItem(String label, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Color(AppConstants.lightGrayColor),
              valueColor: AlwaysStoppedAnimation<Color>(
                JobLensColors.getATSScoreColor(score),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '${score.round()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreDescription(double score) {
    if (score >= 85) return 'Excellent - ATS Ready';
    if (score >= 70) return 'Good - Minor improvements needed';
    if (score >= 55) return 'Fair - Optimization required';
    return 'Poor - Major improvements needed';
  }

  String _getBreakdownLabel(String key) {
    switch (key) {
      case 'completeness': return 'Completeness';
      case 'keywords': return 'Keywords';
      case 'content': return 'Content Quality';
      case 'format': return 'Format';
      case 'experience': return 'Experience';
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement save functionality
              Helpers.showSuccessSnackBar(context, 'Profile saved successfully!');
            },
            icon: const Icon(Icons.save),
            tooltip: 'Save Profile',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ATS Score Card
              _buildATSScoreCard(),
              
              const SizedBox(height: AppConstants.paddingLarge),

              // Basic Information Section
              _buildSectionHeader('Basic Information', Icons.person),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: Validators.validateName,
                        onChanged: (_) => _calculateATSScore(),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => _calculateATSScore(),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number *',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: Validators.validatePhoneNumber,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) => _calculateATSScore(),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location *',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: Validators.validateLocation,
                        onChanged: (_) => _calculateATSScore(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Professional Summary
              _buildSectionHeader('Professional Summary', Icons.description),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: TextFormField(
                    controller: _summaryController,
                    decoration: const InputDecoration(
                      labelText: 'Professional Summary *',
                      hintText: 'Write a compelling summary of your professional experience and goals...',
                      border: InputBorder.none,
                    ),
                    maxLines: 6,
                    validator: Validators.validateSummary,
                    onChanged: (_) => _calculateATSScore(),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Work Experience Section
              _buildSectionHeader('Work Experience', Icons.work),
              _buildExperienceSection(),

              const SizedBox(height: AppConstants.paddingLarge),

              // Education Section
              _buildSectionHeader('Education', Icons.school),
              _buildEducationSection(),

              const SizedBox(height: AppConstants.paddingXLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        children: [
          Icon(icon, color: Color(AppConstants.primaryColor)),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      children: [
        if (_experienceList.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 48,
                    color: Color(AppConstants.darkGrayColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No work experience added yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your professional experience to improve your ATS score',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Color(AppConstants.darkGrayColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showExperienceForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Experience'),
                  ),
                ],
              ),
            ),
          )
        else
          ..._experienceList.asMap().entries.map((entry) {
            final index = entry.key;
            final experience = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(AppConstants.primaryColor),
                  child: Text(
                    experience.company[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(experience.position),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(experience.company),
                    Text(
                      Helpers.formatDateRange(
                        experience.startDate,
                        experience.endDate,
                        experience.isCurrently,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showExperienceForm(experience: experience, index: index);
                    } else if (value == 'delete') {
                      _removeExperience(index);
                    }
                  },
                ),
                isThreeLine: true,
              ),
            );
          }).toList(),
        
        if (_experienceList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.paddingMedium),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showExperienceForm(),
                icon: const Icon(Icons.add),
                label: const Text('Add Another Experience'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return Column(
      children: [
        if (_educationList.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 48,
                    color: Color(AppConstants.darkGrayColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No education added yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your educational background to strengthen your profile',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Color(AppConstants.darkGrayColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showEducationForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Education'),
                  ),
                ],
              ),
            ),
          )
        else
          ..._educationList.asMap().entries.map((entry) {
            final index = entry.key;
            final education = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(AppConstants.accentColor),
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                title: Text(education.degree),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(education.institution),
                    Text(education.fieldOfStudy),
                    Text(
                      Helpers.formatDateRange(
                        education.startDate,
                        education.endDate,
                        education.isCurrently,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEducationForm(education: education, index: index);
                    } else if (value == 'delete') {
                      _removeEducation(index);
                    }
                  },
                ),
                isThreeLine: true,
              ),
            );
          }).toList(),
        
        if (_educationList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.paddingMedium),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showEducationForm(),
                icon: const Icon(Icons.add),
                label: const Text('Add Another Education'),
              ),
            ),
          ),
      ],
    );
  }
}