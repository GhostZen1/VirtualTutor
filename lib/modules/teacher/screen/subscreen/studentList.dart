import 'package:tosl_operation/modules/global.dart';

class StudentListScreen extends StatelessWidget {
  final String courseTitle;
  final VoidCallback onBack;

  const StudentListScreen({
    super.key,
    required this.courseTitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> students = [
      "Alice Johnson",
      "Bob Smith",
      "Charlie Lee",
      "Diana Brown",
    ];

    return Material(
      // <-- Add this wrapper
      color: Colors.white.withOpacity(0.95), // Optional light overlay
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text('$courseTitle - Students'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack, // Call back handler in parent
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text(students[index][0])),
                  title: Text(students[index]),
                  subtitle: Text('Progress: ${(index + 1) * 20}%'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
