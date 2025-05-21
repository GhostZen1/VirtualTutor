import 'package:tosl_operation/modules/global.dart';

class MyCoursesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courseList = [
    {
      'title': "UI Design Basics",
      'teacher': "Mr. Ahmad",
      'progress': 0.6,
      'icon': Icons.design_services
    },
    {
      'title': "Flutter Beginner",
      'teacher': "Miss Sarah",
      'progress': 0.3,
      'icon': Icons.code
    },
  ];

  MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search Field
          TextField(
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
            child: ListView.separated(
              itemCount: courseList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = courseList[index];
                return CourseProgressCard(
                  title: course['title'],
                  teacher: course['teacher'],
                  progress: course['progress'],
                  icon: course['icon'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Card for Courses
class CourseProgressCard extends StatelessWidget {
  final String title;
  final String teacher;
  final double progress;
  final IconData icon;

  const CourseProgressCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toStringAsFixed(0);

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
                  Text("Teacher: $teacher",
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.deepPurple),
                  const SizedBox(height: 4),
                  Text("Progress: $percent%"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
