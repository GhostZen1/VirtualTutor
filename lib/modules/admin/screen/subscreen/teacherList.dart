import 'package:tosl_operation/modules/global.dart';

class ListOfTeachersPage extends StatelessWidget {
  final List<Map<String, String>> teachers = [
    {'name': 'John Doe', 'email': 'john@example.com', 'subject': 'Math'},
    {'name': 'Jane Smith', 'email': 'jane@example.com', 'subject': 'English'},
    {
      'name': 'Michael Lee',
      'email': 'michael@example.com',
      'subject': 'Chemistry'
    },
  ];

  ListOfTeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List of Teachers")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(teacher['name']![0],
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(teacher['name']!,
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text(
                  "Subject: ${teacher['subject']}\nEmail: ${teacher['email']}",
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: IconButton(
                icon: const Icon(Icons.email),
                onPressed: () async {
                  final url = 'mailto:${teacher['email']}';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cannot open email app")),
                    );
                  }
                },
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY();
        },
      ),
    );
  }
}
