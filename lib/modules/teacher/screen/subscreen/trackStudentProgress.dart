import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TrackStudentProgressScreen extends StatelessWidget {
  TrackStudentProgressScreen({super.key});

  final List<Map<String, dynamic>> progressData = [
    {
      "student": "Alice Johnson",
      "course": "UI/UX Mastery",
      "progress": 85,
      "grade": "A"
    },
    {
      "student": "Bob Smith",
      "course": "Flutter Bootcamp",
      "progress": 70,
      "grade": "B"
    },
    {
      "student": "Charlie Lee",
      "course": "UI/UX Mastery",
      "progress": 90,
      "grade": "A+"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Student Progress")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Student")),
            DataColumn(label: Text("Course")),
            DataColumn(label: Text("Progress (%)")),
            DataColumn(label: Text("Grade")),
          ],
          rows: progressData
              .asMap()
              .entries
              .map(
                (entry) => DataRow(
                  cells: [
                    DataCell(Text(entry.value["student"])),
                    DataCell(Text(entry.value["course"])),
                    DataCell(Text("${entry.value['progress']}")),
                    DataCell(Text(entry.value["grade"])),
                  ],
                ),
              )
              .toList(),
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
