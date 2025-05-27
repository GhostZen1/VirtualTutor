import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/admin/controller/adminController.dart';

class ListOfTeachersPage extends StatelessWidget {
  ListOfTeachersPage({super.key});

  final AdminDashboardController controller = AdminDashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List of Teachers")),
      body: FutureBuilder<List<Map<String, String>>>(
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
                      teacher['Username']![0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    teacher['Username']!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    "Subject: ${teacher['Qualification']}\nEmail: ${teacher['Email']}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () async {
                      final url = 'mailto:${teacher['Email']}';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Cannot open email app")),
                        );
                      }
                    },
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideY();
            },
          );
        },
      ),
    );
  }
}
