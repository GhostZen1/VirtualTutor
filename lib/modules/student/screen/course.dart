import 'package:flutter/material.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';
import 'package:tosl_operation/modules/student/screen/chapter.dart';

class MyCoursesScreen extends StatefulWidget {
  final int userId;

  const MyCoursesScreen({super.key, required this.userId});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final CourseController _controller = CourseController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourses() async {
    final data = await _controller.fetchEnrollCourse(widget.userId);
    final courses = (data['courses'] as List)
        .map((course) => course as Map<String, dynamic>)
        .toList();

    setState(() {
      _courses = courses;
      _filteredCourses = courses;
    });
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _courses
          .where((course) =>
              course['title'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'school':
        return Icons.school;
      case 'code':
        return Icons.code;
      case 'design_services':
        return Icons.design_services;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses"),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search your courses...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            // Course List
            Expanded(
              child: _courses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredCourses.isEmpty
                      ? const Center(child: Text('No courses found'))
                      : ListView.separated(
                          itemCount: _filteredCourses.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final course = _filteredCourses[index];
                            return CourseProgressCard(
                              title: course['title'],
                              teacher: course['teacher'],
                              progress: course['progress'],
                              icon: _getIconData(course['icon']),
                              courseId: course['courseId'],
                              userId: widget.userId.toString(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterScreen(
                                      courseId: course['courseId'],
                                      courseTitle: course['title'],
                                      userId: widget.userId.toString(),
                                    ),
                                  ),
                                );
                              },
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

class CourseProgressCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String userId;
  final double progress;
  final IconData icon;
  final String courseId;
  final VoidCallback? onTap;

  const CourseProgressCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.progress,
    required this.icon,
    required this.courseId,
    required this.userId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress).toStringAsFixed(0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ??
            () {
              // Default navigation if no onTap is provided
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterScreen(
                    courseId: courseId,
                    courseTitle: title,
                    userId: userId,
                  ),
                ),
              );
            },
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
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (progress / 100),
                      backgroundColor: Colors.grey[300],
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 4),
                    Text("Progress: $percent%"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
