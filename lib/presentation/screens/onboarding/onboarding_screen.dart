import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblens_cv/config/themes.dart';
import 'package:joblens_cv/presentation/screens/profile/profile_creation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "One Profile, Many CVs",
      description: "Create your profile once and generate tailored CVs for every job application",
      image: Icons.person_outline,
    ),
    OnboardingPage(
      title: "ATS Optimization",
      description: "Ensure your CV passes through Applicant Tracking Systems with our smart optimization",
      image: Icons.analytics_outlined,
    ),
    OnboardingPage(
      title: "Job-Specific Tailoring",
      description: "Simply paste the job description and we'll highlight the most relevant skills and experiences",
      image: Icons.work_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.image,
            size: 150,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button
          TextButton(
            onPressed: () => _goToProfileCreation(),
            child: const Text("Skip"),
          ),
          
          // Dots indicator
          Row(
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          
          // Next or Done button
          ElevatedButton(
            onPressed: () {
              if (_currentPage == _pages.length - 1) {
                _goToProfileCreation();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            child: Text(_currentPage == _pages.length - 1 ? "Get Started" : "Next"),
          ),
        ],
      ),
    );
  }

  void _goToProfileCreation() {
    Get.off(() => const ProfileCreationScreen());
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}