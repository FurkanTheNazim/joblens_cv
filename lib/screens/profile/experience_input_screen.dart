import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_profile.dart';
import '../../config/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';

class ExperienceInputScreen extends StatefulWidget {
  final Experience? experience;
  final Function(Experience) onSave;

  const ExperienceInputScreen({
    super.key,
    this.experience,
    required this.onSave,
  });

  @override
  State<ExperienceInputScreen> createState() => _ExperienceInputScreenState();
}

class _ExperienceInputScreenState extends State<ExperienceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _achievementController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrently = false;
  List<String> _achievements = [];

  @override
  void initState() {
    super.initState();
    if (widget.experience != null) {
      _loadExistingExperience();
    }
  }

  void _loadExistingExperience() {
    final experience = widget.experience!;
    _companyController.text = experience.company;
    _positionController.text = experience.position;
    _descriptionController.text = experience.description;
    _startDate = experience.startDate;
    _endDate = experience.endDate;
    _isCurrently = experience.isCurrently;
    _achievements = List.from(experience.achievements);
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _descriptionController.dispose();
    _achievementController.dispose();
    super.dispose();
  }

  void _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 365 * 2)),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      helpText: 'Select Start Date',
    );
    
    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  void _selectEndDate() async {
    if (_isCurrently) return;
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(1980),
      lastDate: DateTime.now(),
      helpText: 'Select End Date',
    );
    
    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  void _addAchievement() {
    final achievement = _achievementController.text.trim();
    if (achievement.isNotEmpty && !_achievements.contains(achievement)) {
      setState(() {
        _achievements.add(achievement);
        _achievementController.clear();
      });
    }
  }

  void _removeAchievement(int index) {
    setState(() {
      _achievements.removeAt(index);
    });
  }

  void _saveExperience() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null) {
      Helpers.showErrorSnackBar(context, 'Please select a start date');
      return;
    }

    if (!_isCurrently && _endDate == null) {
      Helpers.showErrorSnackBar(context, 'Please select an end date or mark as current position');
      return;
    }

    if (!_isCurrently && _endDate != null && _startDate!.isAfter(_endDate!)) {
      Helpers.showErrorSnackBar(context, 'Start date cannot be after end date');
      return;
    }

    final experience = Experience(
      company: _companyController.text.trim(),
      position: _positionController.text.trim(),
      startDate: _startDate!,
      endDate: _isCurrently ? null : _endDate,
      isCurrently: _isCurrently,
      description: _descriptionController.text.trim(),
      achievements: _achievements,
    );

    widget.onSave(experience);
    Navigator.of(context).pop();
  }

  void _showATSOptimizationTips() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Color(AppConstants.accentColor),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ATS Optimization Tips',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Color(AppConstants.accentColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildTipCard(
                      'Use Action Verbs',
                      'Start bullet points with strong action verbs like:\n'
                      '• Achieved, Developed, Implemented\n'
                      '• Managed, Led, Created\n'
                      '• Improved, Optimized, Increased',
                      Icons.flash_on,
                    ),
                    _buildTipCard(
                      'Quantify Achievements',
                      'Include specific numbers and metrics:\n'
                      '• "Increased sales by 25%"\n'
                      '• "Managed team of 12 people"\n'
                      '• "Reduced processing time by 3 hours"',
                      Icons.trending_up,
                    ),
                    _buildTipCard(
                      'Use Keywords',
                      'Include relevant industry keywords:\n'
                      '• Technical skills mentioned in job posting\n'
                      '• Industry-specific terminology\n'
                      '• Software and tools you\'ve used',
                      Icons.key,
                    ),
                    _buildTipCard(
                      'Keep It Relevant',
                      'Focus on achievements that:\n'
                      '• Match the job requirements\n'
                      '• Show progression and growth\n'
                      '• Demonstrate impact and results',
                      Icons.target,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String content, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(AppConstants.primaryColor)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.experience == null ? 'Add Experience' : 'Edit Experience',
        ),
        actions: [
          IconButton(
            onPressed: _showATSOptimizationTips,
            icon: const Icon(Icons.help_outline),
            tooltip: 'ATS Tips',
          ),
          TextButton(
            onPressed: _saveExperience,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
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
              // Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Icon(
                        Icons.work,
                        color: Color(AppConstants.primaryColor),
                        size: 32,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Work Experience',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Showcase your professional experience and achievements',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Color(AppConstants.darkGrayColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),

              // Company Name
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  hintText: 'e.g., Google, Microsoft, Startup Inc.',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: Validators.validateCompanyName,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Position/Job Title
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Job Title *',
                  hintText: 'e.g., Software Engineer, Product Manager',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: Validators.validateJobTitle,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Date Section
              Text(
                'Employment Period',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),

              // Date Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectStartDate,
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(AppConstants.lightGrayColor)),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                          color: Color(AppConstants.lightGrayColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date *',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _startDate != null 
                                  ? Helpers.formatDateFull(_startDate) 
                                  : 'Select Date',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _startDate != null 
                                    ? Color(AppConstants.textColor)
                                    : Color(AppConstants.darkGrayColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.paddingMedium),
                  
                  Expanded(
                    child: InkWell(
                      onTap: _isCurrently ? null : _selectEndDate,
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(AppConstants.lightGrayColor)),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                          color: _isCurrently 
                              ? Color(AppConstants.darkGrayColor).withOpacity(0.3)
                              : Color(AppConstants.lightGrayColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isCurrently 
                                  ? 'Present'
                                  : (_endDate != null 
                                      ? Helpers.formatDateFull(_endDate) 
                                      : 'Select Date'),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _isCurrently || _endDate != null
                                    ? Color(AppConstants.textColor)
                                    : Color(AppConstants.darkGrayColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Currently Working Checkbox
              CheckboxListTile(
                value: _isCurrently,
                onChanged: (value) {
                  setState(() {
                    _isCurrently = value ?? false;
                    if (_isCurrently) {
                      _endDate = null;
                    }
                  });
                },
                title: const Text('I currently work here'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Job Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description *',
                  hintText: 'Describe your role and responsibilities...',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: Validators.validateExperienceDescription,
                textInputAction: TextInputAction.newline,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Achievements Section
              Row(
                children: [
                  Text(
                    'Key Achievements',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_achievements.length} added',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Color(AppConstants.darkGrayColor),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),

              // Add Achievement Input
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _achievementController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Increased sales by 30% in Q1 2023',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _addAchievement(),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  ElevatedButton(
                    onPressed: _addAchievement,
                    child: const Text('Add'),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Achievements List
              if (_achievements.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(AppConstants.lightGrayColor)),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Column(
                    children: _achievements.asMap().entries.map((entry) {
                      final index = entry.key;
                      final achievement = entry.value;
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(AppConstants.accentColor),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(achievement),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeAchievement(index),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: AppConstants.paddingLarge),

              // ATS Quick Tips
              Card(
                color: Color(AppConstants.secondaryColor).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            color: Color(AppConstants.secondaryColor),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Quick ATS Tips',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Color(AppConstants.secondaryColor),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _showATSOptimizationTips,
                            child: const Text('More Tips'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      const Text(
                        '• Use action verbs and quantify your achievements\n'
                        '• Include relevant keywords from job descriptions\n'
                        '• Focus on results and impact, not just duties',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingXLarge),
            ],
          ),
        ),
      ),
    );
  }
}