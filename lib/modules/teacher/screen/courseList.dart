import 'package:flutter/material.dart';
import 'package:tosl_operation/modules/global.dart';

class CourseListScreen extends StatelessWidget {
  final Function(String courseTitle) onSelectCourse;

  CourseListScreen({super.key, required this.onSelectCourse});

  final List<Map<String, dynamic>> courseList = [
    {
      'title': "UI/UX Mastery",
      'total': "32 Student Enrolled",
      'icon': Icons.design_services
    },
    {
      'title': "Flutter Bootcamp",
      'total': "21 Student Enrolled",
      'icon': Icons.code
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search your courses...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: courseList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final course = courseList[index];
                  return GestureDetector(
                    onTap: () {
                      onSelectCourse(course['title']);
                    },
                    child: CourseProgressCard(
                      title: course['title'],
                      ttlEnroll: course['total'],
                      icon: course['icon'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Card for Courses
class CourseProgressCard extends StatelessWidget {
  final String title;
  final String ttlEnroll;
  final IconData icon;

  const CourseProgressCard({
    super.key,
    required this.title,
    required this.ttlEnroll,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Total Student Enrolled: $ttlEnroll",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
