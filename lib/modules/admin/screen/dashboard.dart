import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tosl_operation/modules/admin/component/cardWidget.dart';
import 'package:tosl_operation/modules/admin/screen/subscreen/courseAvailable.dart';
import 'package:tosl_operation/modules/admin/screen/subscreen/hotPickCourse.dart';
import 'package:tosl_operation/modules/admin/screen/subscreen/teacherList.dart';
import 'package:tosl_operation/modules/admin/screen/subscreen/teacherRating.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     tooltip: 'Logout',
        //     onPressed: () {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => const LoginScreen()),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              "Welcome, Admin!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20), // Adjusted font size
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 8),
            Text(
              "Manage your courses and teachers efficiently.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14), // Adjusted font size
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 24),

            // Quick Stats Section
            Text(
              "Quick Stats",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18), // Adjusted font size
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2, // Two cards per row
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5, // Adjust the aspect ratio as needed
              children: [
                buildStatCard(
                  context,
                  "Total Courses",
                  "12",
                  Colors.blueAccent,
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
                buildStatCard(
                  context,
                  "Total Teachers",
                  "8",
                  Colors.green,
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
                buildStatCard(
                  context,
                  "Pending Approvals",
                  "3",
                  Colors.redAccent,
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
              ],
            ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
            const SizedBox(height: 24),

            // Quick Actions Section
            Text(
              "Quick Actions",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18), // Adjusted font size
            ).animate().fadeIn(duration: 500.ms, delay: 800.ms),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2, // Two cards per row
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5, // Adjust the aspect ratio as needed
              children: [
                buildNavCard(
                  context,
                  "Hot Pick Courses",
                  Icons.local_fire_department,
                  Colors.redAccent,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HotPickCoursesPage())),
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
                buildNavCard(
                  context,
                  "Teacher Ratings",
                  Icons.star,
                  Colors.amber,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TeacherRatingsPage())),
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
                buildNavCard(
                  context,
                  "Courses Available",
                  Icons.library_books,
                  Colors.green,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CoursesAvailablePage())),
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
                buildNavCard(
                  context,
                  "List of Teachers",
                  Icons.list,
                  Colors.blueAccent,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ListOfTeachersPage())),
                  width: isWideScreen ? screenWidth * 0.45 : screenWidth * 0.45,
                ),
              ],
            ).animate().fadeIn(duration: 500.ms, delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
