import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/analyzeStudentPerformance.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageLearningMaterial.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageQuiz.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/studentList.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/trackStudentProgress.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/viewStudentReview.dart';

class TeacherHomeScreen extends StatelessWidget {
  final int userId;

  TeacherHomeScreen({super.key, required this.userId});

  // Mock teacher data (replace with backend call using userId)
  final String teacherName = "Dr. Smith";
  final List<Map<String, dynamic>> courses = [
    {"title": "UI/UX Mastery", "enrollments": 32, "color": Colors.blueAccent},
    {
      "title": "Flutter Bootcamp",
      "enrollments": 21,
      "color": Colors.orangeAccent
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, $teacherName",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        "Welcome back!",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  // const CircleAvatar(
                  //   radius: 24,
                  //   backgroundImage: AssetImage('assets/teacher_avatar.png'),
                  // ),
                ],
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 20),

              // Search Bar
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 4,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       hintText: "Search courses or students...",
              //       border: InputBorder.none,
              //       prefixIcon: Icon(Icons.search, color: Colors.grey),
              //     ),
              //   ),
              // ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
              // const SizedBox(height: 20),

              // Filters
              Wrap(
                spacing: 10, // space between chips
                runSpacing: 10, // space between rows if they wrap
                children: [
                  // _filterChip(
                  //   context,
                  //   icon: Icons.menu_book,
                  //   label: "My Courses",
                  //   color: Colors.blue,
                  //   onTap: () {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //           content: Text("Navigate to Courses List")),
                  //     );
                  //   },
                  // ),
                  _filterChip(
                    context,
                    icon: Icons.feedback,
                    label: "Feedback",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewStudentReviewScreen(),
                        ),
                      );
                    },
                  ),
                  _filterChip(
                    context,
                    icon: Icons.bar_chart,
                    label: "Analytics",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnalyzeStudentPerformanceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms),

              const SizedBox(height: 15),

              // Course Cards
              // Text(
              //   "Your Courses",
              //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //         fontWeight: FontWeight.bold,
              //       ),
              // ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
              // const SizedBox(height: 12),
              // SizedBox(
              //   height: 160,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: courses.length,
              //     itemBuilder: (context, index) {
              //       final course = courses[index];
              //       return _courseCard(
              //         title: course["title"],
              //         description: "${course['enrollments']} students enrolled",
              //         color: course["color"],
              //       ).animate().fadeIn(
              //           duration: 300.ms, delay: (index * 100 + 800).ms);
              //     },
              //   ),
              // ),
              // const SizedBox(height: 20),

              // Modules Section
              Text(
                "Teacher Modules",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(duration: 500.ms, delay: 1000.ms),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _moduleCard(
                    context,
                    icon: Icons.people,
                    label: "View Student List + Progress",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentListScreen(
                            courseTitle:
                                "UI/UX Mastery", // Replace with selected course
                            onBack: null,
                          ),
                        ),
                      );
                    },
                  ),
                  _moduleCard(
                    context,
                    icon: Icons.book,
                    label: "Manage Learning Material",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ManageLearningMaterialScreen(),
                        ),
                      );
                    },
                  ),
                  _moduleCard(
                    context,
                    icon: Icons.quiz,
                    label: "Manage Quiz / Activity",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageQuizScreen(),
                        ),
                      );
                    },
                  ),
                  _moduleCard(
                    context,
                    icon: Icons.show_chart,
                    label: "Track Student Progress",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackStudentProgressScreen(),
                        ),
                      );
                    },
                  ),
                  // _moduleCard(
                  //   context,
                  //   icon: Icons.reviews,
                  //   label: "View Student Review",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => ViewStudentReviewScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // _moduleCard(
                  //   context,
                  //   icon: Icons.analytics,
                  //   label: "Analyze Student Performance",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             AnalyzeStudentPerformanceScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(icon, color: color, size: 18),
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color, fontWeight: FontWeight.w600, fontSize: 10),
        ),
        backgroundColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _courseCard({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const Icon(Icons.school, color: Colors.white, size: 30),
      //     const Spacer(),
      //     Text(
      //       title,
      //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //           ),
      //     ),
      //     const SizedBox(height: 8),
      //     Text(
      //       description,
      //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
      //             color: Colors.white70,
      //           ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _moduleCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blueAccent),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
