import 'package:tosl_operation/modules/global.dart';

class CoursesAvailablePage extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {
      'title': 'AI for Beginners',
      'description': 'Intro to AI concepts',
      'category': 'Technology'
    },
    {
      'title': 'Flutter Development',
      'description': 'Build mobile apps',
      'category': 'Development'
    },
    {
      'title': 'Data Science 101',
      'description': 'Learn data analysis',
      'category': 'Data Science'
    },
    {
      'title': 'Cybersecurity Basics',
      'description': 'Stay secure online',
      'category': 'Security'
    },
  ];

  CoursesAvailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courses Available")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  course['category']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                course['title']!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                "${course['description']!} • Category: ${course['category']}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected ${course['title']}")),
                );
              },
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: (index * 100).ms)
              .slideY();
        },
      ),
    );
  }
}
