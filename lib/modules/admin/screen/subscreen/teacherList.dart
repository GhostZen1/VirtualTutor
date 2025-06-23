import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/admin/controller/adminController.dart';

class ListOfTeachersPage extends StatelessWidget {
  ListOfTeachersPage({super.key});
  final AdminDashboardController controller = AdminDashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List of Teachers")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.fetchListTeacher(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No teachers found."));
          }

          final teachers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      teacher['Username'][0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(teacher['Username'],
                      style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text(
                      "Qualification: ${teacher['Qualification']}\nEmail: ${teacher['Email']}"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(teacher['Username']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Qualification: ${teacher['Qualification']}"),
                            const SizedBox(height: 8),
                            Text("Email: ${teacher['Email']}"),
                            const SizedBox(height: 12),
                            Text("Courses:",
                                style: Theme.of(context).textTheme.titleMedium),
                            ...?teacher['Courses']
                                ?.map<Widget>((c) => Text("• $c"))
                                .toList(),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(duration: 300.ms).slideY();
            },
          );
        },
      ),
    );
  }
}
