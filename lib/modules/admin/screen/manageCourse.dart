import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tosl_operation/modules/global.dart';

class ManageCourseScreen extends StatefulWidget {
  const ManageCourseScreen({super.key});

  @override
  _ManageCourseScreenState createState() => _ManageCourseScreenState();
}

class _ManageCourseScreenState extends State<ManageCourseScreen> {
  final List<Map<String, String>> courses = [
    {"course": "Physics", "teacher": "Unassigned", "status": "Unassigned"},
    {"course": "Chemistry", "teacher": "Ms. Liza", "status": "Assigned"},
  ];

  final List<String> teachers = [
    "Ms. Liza",
    "Mr. John",
    "Dr. Smith",
    "Unassigned"
  ];

  final _formKey = GlobalKey<FormBuilderState>();

  void _showTeacherAssignmentModal(BuildContext context, int index) {
    final course = courses[index];
    String selectedTeacher = course["teacher"] ?? "Unassigned";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Assign Teacher to ${course['course']}"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return FormBuilder(
                child: FormBuilderDropdown<String>(
                  name: 'teacher',
                  initialValue: selectedTeacher,
                  decoration: InputDecoration(
                    labelText: 'Teacher',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: teachers
                      .map((teacher) => DropdownMenuItem(
                          value: teacher, child: Text(teacher)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedTeacher = value;
                    }
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  courses[index]["teacher"] = selectedTeacher;
                  courses[index]["status"] = selectedTeacher == "Unassigned"
                      ? "Unassigned"
                      : "Assigned";
                });
                Navigator.of(context).pop();
              },
              child: const Text("Assign"),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scale();
      },
    );
  }

  void _showAddCourseModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add New Course"),
          content: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilderTextField(
                    name: 'course',
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a course name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderDropdown<String>(
                    name: 'teacher',
                    initialValue: 'Unassigned',
                    decoration: InputDecoration(
                      labelText: 'Teacher',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    items: teachers
                        .map((teacher) => DropdownMenuItem(
                            value: teacher, child: Text(teacher)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  final formData = _formKey.currentState!.value;
                  setState(() {
                    courses.add({
                      "course": formData['course'],
                      "teacher": formData['teacher'],
                      "status": formData['teacher'] == "Unassigned"
                          ? "Unassigned"
                          : "Assigned",
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add Course"),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scale();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Courses")),
      body: courses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "No courses available",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add a new course using the button below",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
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
                      backgroundColor: course["status"] == "Assigned"
                          ? Colors.green
                          : Colors.redAccent,
                      child: Icon(
                        course["status"] == "Assigned"
                            ? Icons.check_circle
                            : Icons.warning,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      course["course"] ?? "",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Teacher: ${course["teacher"]}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Status: ${course["status"]}",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: course["status"] == "Assigned"
                                        ? Colors.green
                                        : Colors.redAccent,
                                  ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showTeacherAssignmentModal(context, index),
                    ),
                    onTap: () => _showTeacherAssignmentModal(context, index),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideX(delay: (index * 100).ms);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCourseModal(context),
        tooltip: 'Add Course',
        child: const Icon(Icons.add),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
