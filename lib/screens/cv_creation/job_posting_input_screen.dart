import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/job_posting.dart';
import '../../data/services/ats_service.dart';
import '../../config/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';

class JobPostingInputScreen extends StatefulWidget {
  const JobPostingInputScreen({super.key});

  @override
  State<JobPostingInputScreen> createState() => _JobPostingInputScreenState();
}

class _JobPostingInputScreenState extends State<JobPostingInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();

  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;
  int _currentStep = 0;

  @override
  void dispose() {
    _urlController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _analyzeJobPosting() async {
    if (_currentStep == 0) {
      // URL Analysis Step
      if (_urlController.text.isNotEmpty) {
        final urlValidation = Validators.validateUrl(_urlController.text);
        if (urlValidation != null) {
          Helpers.showErrorSnackBar(context, urlValidation);
          return;
        }
        _analyzeFromUrl();
      } else {
        setState(() {
          _currentStep = 1; // Move to manual input
        });
      }
    } else {
      // Manual Input Analysis
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _analyzeFromText();
    }
  }

  void _analyzeFromUrl() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate URL analysis
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would make API calls to extract job posting data
    final mockAnalysis = ATSService.analyzeJobPosting(
      "Software Engineer position at Tech Company. "
      "Requirements: 3+ years experience with Flutter, Dart, Firebase. "
      "Responsibilities include developing mobile applications, code reviews, "
      "and collaborating with cross-functional teams. "
      "Preferred skills: React Native, Node.js, AWS.",
    );

    setState(() {
      _isAnalyzing = false;
      _analysisResult = mockAnalysis;
      _titleController.text = "Software Engineer";
      _companyController.text = "Tech Company";
      _descriptionController.text = 
          "Software Engineer position requiring 3+ years experience with Flutter, Dart, and Firebase. "
          "Responsibilities include developing mobile applications, conducting code reviews, and "
          "collaborating with cross-functional teams.";
    });

    Helpers.showSuccessSnackBar(context, 'Job posting analyzed successfully!');
  }

  void _analyzeFromText() async {
    setState(() {
      _isAnalyzing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final analysis = ATSService.analyzeJobPosting(_descriptionController.text);

    setState(() {
      _isAnalyzing = false;
      _analysisResult = analysis;
    });

    Helpers.showSuccessSnackBar(context, 'Job description analyzed successfully!');
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _analysisResult = null;
      _urlController.clear();
      _descriptionController.clear();
      _titleController.clear();
      _companyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Analysis'),
        actions: [
          if (_analysisResult != null)
            IconButton(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh),
              tooltip: 'Analyze Another Job',
            ),
        ],
      ),
      body: _isAnalyzing 
          ? _buildLoadingView()
          : _analysisResult != null 
              ? _buildAnalysisResults()
              : _buildInputForm(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Analyzing Job Posting...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color(AppConstants.darkGrayColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: Color(AppConstants.secondaryColor),
                      size: 32,
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job Posting Analysis',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get insights and optimization tips for any job posting',
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

            if (_currentStep == 0) ...[
              // URL Input Step
              Text(
                'Option 1: Analyze from URL',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),

              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Job Posting URL',
                  hintText: 'https://example.com/job-posting',
                  prefixIcon: Icon(Icons.link),
                  suffixIcon: Icon(Icons.paste),
                ),
                keyboardType: TextInputType.url,
                onFieldSubmitted: (_) => _analyzeJobPosting(),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _analyzeJobPosting,
                  child: const Text('Analyze from URL'),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(AppConstants.darkGrayColor),
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Manual Input Option
              Text(
                'Option 2: Manual Input',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  child: const Text('Enter Job Details Manually'),
                ),
              ),
            ] else ...[
              // Manual Input Step
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _currentStep = 0),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Enter Job Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),

              // Job Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title *',
                  hintText: 'e.g., Software Engineer',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: Validators.validateJobTitle,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Company Name
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  hintText: 'e.g., Google, Microsoft',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: Validators.validateCompanyName,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Job Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description *',
                  hintText: 'Paste the complete job description here...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) => Validators.validateRequired(value, 'Job description'),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _analyzeJobPosting,
                  child: const Text('Analyze Job Description'),
                ),
              ),
            ],

            const SizedBox(height: AppConstants.paddingLarge),

            // Tips Card
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
                          'Analysis Tips',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Color(AppConstants.accentColor),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    const Text(
                      '• Copy the complete job description for better analysis\n'
                      '• Include requirements, responsibilities, and preferred qualifications\n'
                      '• Our AI will extract key skills and suggest profile optimizations\n'
                      '• Use the insights to tailor your resume for better ATS compatibility',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final keywords = _analysisResult!['keywords'] as List<String>;
    final skills = _analysisResult!['skills'] as List<String>;
    final suggestions = _analysisResult!['suggestions'] as List<String>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Header
          Card(
            color: Colors.green.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysis Complete!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Here are the key insights from the job posting',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Job Details
          if (_titleController.text.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.work, color: Color(AppConstants.primaryColor)),
                        const SizedBox(width: 8),
                        Text(_titleController.text, style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.business, color: Color(AppConstants.primaryColor)),
                        const SizedBox(width: 8),
                        Text(_companyController.text, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
          ],

          // Required Skills
          _buildAnalysisCard(
            'Required Skills',
            skills,
            Icons.star,
            Color(AppConstants.primaryColor),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Key Keywords
          _buildAnalysisCard(
            'Important Keywords',
            keywords,
            Icons.key,
            Color(AppConstants.secondaryColor),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Optimization Suggestions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Optimization Suggestions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...suggestions.map((suggestion) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(suggestion),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Analyze Another'),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to profile optimization
                    Helpers.showSuccessSnackBar(context, 'Profile optimization coming soon!');
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Optimize Profile'),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingXLarge),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, List<String> items, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${items.length} found',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Color(AppConstants.darkGrayColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.take(10).map((item) => Chip(
                label: Text(
                  item,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: color.withOpacity(0.1),
                side: BorderSide(color: color.withOpacity(0.3)),
              )).toList(),
            ),
            if (items.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${items.length - 10} more...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Color(AppConstants.darkGrayColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}