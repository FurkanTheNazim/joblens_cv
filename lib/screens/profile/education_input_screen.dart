import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_profile.dart';
import '../../config/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';

class EducationInputScreen extends StatefulWidget {
  final Education? education;
  final Function(Education) onSave;

  const EducationInputScreen({
    super.key,
    this.education,
    required this.onSave,
  });

  @override
  State<EducationInputScreen> createState() => _EducationInputScreenState();
}

class _EducationInputScreenState extends State<EducationInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedDegree;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrently = false;

  @override
  void initState() {
    super.initState();
    if (widget.education != null) {
      _loadExistingEducation();
    }
  }

  void _loadExistingEducation() {
    final education = widget.education!;
    _institutionController.text = education.institution;
    _degreeController.text = education.degree;
    _fieldOfStudyController.text = education.fieldOfStudy;
    _descriptionController.text = education.description;
    _selectedDegree = education.degree;
    _startDate = education.startDate;
    _endDate = education.endDate;
    _isCurrently = education.isCurrently;
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 365 * 4)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Select Start Date',
    );
    
    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
        // Reset end date if it's before start date
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
      firstDate: _startDate ?? DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Select End Date',
    );
    
    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  void _saveEducation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null) {
      Helpers.showErrorSnackBar(context, 'Please select a start date');
      return;
    }

    if (!_isCurrently && _endDate == null) {
      Helpers.showErrorSnackBar(context, 'Please select an end date or mark as currently studying');
      return;
    }

    // Validate date range
    if (!_isCurrently && _endDate != null && _startDate!.isAfter(_endDate!)) {
      Helpers.showErrorSnackBar(context, 'Start date cannot be after end date');
      return;
    }

    final education = Education(
      institution: _institutionController.text.trim(),
      degree: _selectedDegree ?? _degreeController.text.trim(),
      fieldOfStudy: _fieldOfStudyController.text.trim(),
      startDate: _startDate!,
      endDate: _isCurrently ? null : _endDate,
      isCurrently: _isCurrently,
      description: _descriptionController.text.trim(),
    );

    widget.onSave(education);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.education == null ? 'Add Education' : 'Edit Education',
        ),
        actions: [
          TextButton(
            onPressed: _saveEducation,
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
                        Icons.school,
                        color: Color(AppConstants.primaryColor),
                        size: 32,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Education Details',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add your educational background to strengthen your profile',
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

              // Institution Name
              TextFormField(
                controller: _institutionController,
                decoration: const InputDecoration(
                  labelText: 'Institution Name *',
                  hintText: 'e.g., University of California, Berkeley',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: Validators.validateInstitution,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Degree Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedDegree,
                decoration: const InputDecoration(
                  labelText: 'Degree Type *',
                  hintText: 'Select your degree',
                  prefixIcon: Icon(Icons.military_tech),
                ),
                items: AppConstants.degreeTypes.map((degree) {
                  return DropdownMenuItem(
                    value: degree,
                    child: Text(degree),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDegree = value;
                    if (value != null) {
                      _degreeController.text = value;
                    }
                  });
                },
                validator: (value) => Validators.validateDegree(value),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Field of Study
              TextFormField(
                controller: _fieldOfStudyController,
                decoration: const InputDecoration(
                  labelText: 'Field of Study *',
                  hintText: 'e.g., Computer Science, Business Administration',
                  prefixIcon: Icon(Icons.book),
                ),
                validator: Validators.validateFieldOfStudy,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Date Section
              Text(
                'Duration',
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

              // Currently Studying Checkbox
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
                title: const Text('I am currently studying here'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Relevant coursework, achievements, GPA, etc.',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // ATS Tips Card
              Card(
                color: Color(AppConstants.accentColor).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Color(AppConstants.accentColor),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ATS Tips',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Color(AppConstants.accentColor),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      const Text(
                        '• Use full institution names (avoid abbreviations)\n'
                        '• Include relevant coursework if it matches job requirements\n'
                        '• Mention honors, dean\'s list, or high GPA if applicable\n'
                        '• Keep descriptions concise and relevant',
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