import 'package:tosl_operation/modules/global.dart';

class HotPickCoursesPage extends StatelessWidget {
  final List<Map<String, dynamic>> hotPicks = [
    {"title": "AI for Beginners", "enrollments": 120, "rating": 4.8},
    {"title": "Flutter Mobile Development", "enrollments": 95, "rating": 4.6},
    {"title": "Data Science 101", "enrollments": 80, "rating": 4.7},
  ];

  HotPickCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hot Pick Courses")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔥 Most Popular Courses This Month",
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: hotPicks.length,
                itemBuilder: (context, index) {
                  final course = hotPicks[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          "#${index + 1}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        course["title"],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        "${course['enrollments']} enrollments • Rating: ${course['rating']}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Selected ${course['title']}")),
                        );
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                      .slideX();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
