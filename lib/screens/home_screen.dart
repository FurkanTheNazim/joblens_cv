import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/constants.dart';
import '../config/themes.dart';
import 'profile/profile_screen.dart';
import 'cv_creation/cv_templates_screen.dart';
import 'cv_creation/job_posting_input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const ProfileScreen(),
    const CVTemplatesScreen(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(AppConstants.primaryColor),
        unselectedItemColor: Color(AppConstants.darkGrayColor),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'CV Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobLensCV Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              color: Color(AppConstants.primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to JobLensCV',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Create ATS-optimized resumes that get noticed',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.to(() => const ProfileScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(AppConstants.primaryColor),
                      ),
                      child: const Text('Complete Your Profile'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppConstants.paddingMedium,
              crossAxisSpacing: AppConstants.paddingMedium,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  context,
                  'Build CV',
                  'Create your ATS-optimized resume',
                  Icons.description,
                  Color(AppConstants.accentColor),
                  () => Get.to(() => const CVTemplatesScreen()),
                ),
                _buildActionCard(
                  context,
                  'Analyze Job',
                  'Get job posting insights',
                  Icons.analytics,
                  Color(AppConstants.secondaryColor),
                  () => Get.to(() => const JobPostingInputScreen()),
                ),
                _buildActionCard(
                  context,
                  'My Profile',
                  'Edit your information',
                  Icons.person,
                  Colors.purple,
                  () => Get.to(() => const ProfileScreen()),
                ),
                _buildActionCard(
                  context,
                  'ATS Tips',
                  'Learn optimization tips',
                  Icons.lightbulb,
                  Colors.orange,
                  () => _showATSTips(context),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Features Overview
            Text(
              'Why JobLensCV?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),

            ..._buildFeatureCards(),

            const SizedBox(height: AppConstants.paddingXLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Color(AppConstants.darkGrayColor),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards() {
    final features = [
      {
        'icon': Icons.auto_awesome,
        'title': 'ATS Optimization',
        'description': 'Automatically optimize your resume for ATS systems with keyword analysis and formatting suggestions.',
      },
      {
        'icon': Icons.speed,
        'title': 'Smart Matching',
        'description': 'Match your profile to job postings and get personalized recommendations for improvement.',
      },
      {
        'icon': Icons.palette,
        'title': 'Professional Templates',
        'description': 'Choose from multiple ATS-friendly templates designed by HR professionals.',
      },
    ];

    return features.map((feature) => Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(AppConstants.primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: Color(AppConstants.primaryColor),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )).toList();
  }

  void _showATSTips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'ATS Optimization Tips',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Expanded(
              child: ListView(
                children: [
                  _buildTipCard(
                    'Use Standard Headings',
                    'Use standard section headings like "Work Experience", "Education", "Skills". Avoid creative headings that ATS might not recognize.',
                    Icons.title,
                  ),
                  _buildTipCard(
                    'Include Keywords',
                    'Analyze job descriptions and include relevant keywords throughout your resume, especially in skills and experience sections.',
                    Icons.key,
                  ),
                  _buildTipCard(
                    'Simple Formatting',
                    'Use simple, clean formatting. Avoid tables, columns, headers, footers, and graphics that ATS can\'t read.',
                    Icons.format_align_left,
                  ),
                  _buildTipCard(
                    'Save as PDF or DOCX',
                    'Unless specified otherwise, save your resume as PDF or DOCX format for best ATS compatibility.',
                    Icons.file_present,
                  ),
                  _buildTipCard(
                    'Quantify Achievements',
                    'Use numbers and metrics to demonstrate your impact. For example: "Increased sales by 25%" or "Managed team of 10".',
                    Icons.trending_up,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Color(AppConstants.primaryColor)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CVTemplatesScreen extends StatelessWidget {
  const CVTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Templates'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'CV Templates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Choose from professional templates'),
            SizedBox(height: 24),
            Text('Coming Soon!'),
          ],
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Settings'),
              subtitle: const Text('Manage your profile information'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.to(() => const ProfileScreen()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              subtitle: const Text('Choose app appearance'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement theme selection
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              subtitle: const Text('Get help and send feedback'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement help section
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              subtitle: Text('JobLensCV v${AppConstants.appVersion}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: AppConstants.appVersion,
                  applicationIcon: const Icon(Icons.work),
                  children: [
                    const Text('Create ATS-optimized resumes that get noticed by employers.'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}