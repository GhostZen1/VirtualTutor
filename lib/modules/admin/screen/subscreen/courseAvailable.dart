import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/admin/controller/adminController.dart';

class CoursesAvailablePage extends StatelessWidget {
  CoursesAvailablePage({super.key});

  final AdminDashboardController controller = AdminDashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courses Available")),
      body: FutureBuilder<List<Map<String, String>>>(
        future: controller.fetchListCourseAvailable(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No course found."));
          }

          final courses = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      (course['Name'] ?? 'N')[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    course['Name'] ?? 'Untitled',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category first
                      Text(
                        "Category: ${course['Category'] ?? 'Unknown'}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        course['Description'] ?? 'No description',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Selected ${course['Name']}")),
                    );
                  },
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                  .slideY();
            },
          );
        },
      ),
    );
  }
}
