import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ManageQuizScreen extends StatefulWidget {
  const ManageQuizScreen({super.key});

  @override
  ManageQuizScreenState createState() => ManageQuizScreenState();
}

class ManageQuizScreenState extends State<ManageQuizScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<Map<String, dynamic>> quizzes = [
    {
      "title": "UI/UX Quiz 1",
      "questions": 5,
      "type": "Multiple Choice",
      "dueDate": "2025-05-20"
    },
    {
      "title": "Flutter Basics",
      "questions": 10,
      "type": "True/False",
      "dueDate": "2025-05-22"
    },
  ];

  void _addQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Add Quiz"),
        content: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'Quiz Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'questions',
                decoration: InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormBuilderDropdown<String>(
                name: 'type',
                decoration: InputDecoration(
                  labelText: 'Quiz Type',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                items: ['Multiple Choice', 'True/False', 'Short Answer']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                initialValue: 'Multiple Choice',
              ),
              const SizedBox(height: 12),
              FormBuilderDateTimePicker(
                name: 'dueDate',
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                inputType: InputType.date,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a due date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.saveAndValidate()) {
                setState(() {
                  final formData = _formKey.currentState!.value;
                  quizzes.add({
                    "title": formData['title'],
                    "questions": int.parse(formData['questions']),
                    "type": formData['type'],
                    "dueDate": formData['dueDate'].toString().split(' ')[0],
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Quiz added")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Quiz / Activity")),
      body: quizzes.isEmpty
          ? Center(
              child: Text(
                "No quizzes available",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.quiz, color: Colors.blueAccent),
                    title: Text(
                      quiz['title'],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${quiz['type']} • ${quiz['questions']} questions • Due: ${quiz['dueDate']}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          quizzes.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Quiz deleted")),
                        );
                      },
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                    .slideX();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuiz,
        tooltip: 'Add Quiz',
        child: const Icon(Icons.add),
      ),
    );
  }
}
