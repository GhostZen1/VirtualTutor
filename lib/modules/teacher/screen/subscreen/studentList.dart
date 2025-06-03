import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StudentListScreen extends StatelessWidget {
  final String courseTitle;
  final VoidCallback? onBack;

  StudentListScreen({
    super.key,
    required this.courseTitle,
    this.onBack,
  });

  final List<Map<String, dynamic>> students = [
    {
      "name": "Alice Johnson",
      "progress": 85,
      "quizScore": 90,
      "materialsCompleted": "8/10"
    },
    {
      "name": "Bob Smith",
      "progress": 70,
      "quizScore": 85,
      "materialsCompleted": "6/10"
    },
    {
      "name": "Charlie Lee",
      "progress": 90,
      "quizScore": 95,
      "materialsCompleted": "9/10"
    },
    {
      "name": "Diana Brown",
      "progress": 65,
      "quizScore": 80,
      "materialsCompleted": "5/10"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$courseTitle - Students'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack ?? () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(student["name"][0]),
              ),
              title: Text(
                student["name"],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Progress: ${student['progress']}%"),
                  Text("Quiz Score: ${student['quizScore']}"),
                  Text("Materials Completed: ${student['materialsCompleted']}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Message ${student['name']}")),
                  );
                },
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("View ${student['name']} profile")),
                );
              },
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: (index * 100).ms)
              .slideX();
        },
      ),
    );
  }
}
