import 'package:tosl_operation/modules/admin/controller/adminController.dart';
import 'package:tosl_operation/modules/global.dart';

class ManageCourseHelper {
  static Future<(List<String>, Map<String, String>)>
      fetchTeachersAndMap() async {
    try {
      final fetchedTeachers =
          await AdminDashboardController().fetchListTeacher();
      final teachersList =
          fetchedTeachers.map((t) => t["Username"] ?? "Unassigned").toList();
      if (!teachersList.contains("Unassigned")) {
        teachersList.add("Unassigned");
      }
      final teacherMap = {
        for (var teacher in fetchedTeachers)
          teacher["Username"] ?? "Unassigned": teacher["UserId"] ?? "",
      };
      teacherMap["Unassigned"] = "";
      return (teachersList, teacherMap);
    } catch (e) {
      return (["Unassigned"], {"Unassigned": ""});
    }
  }

  static void showTeacherAssignmentModal(
    BuildContext context,
    int index,
    List<Map<String, String>> courses,
    List<String> teachersList,
    Map<String, String> teacherMap,
    VoidCallback onUpdate,
  ) {
    String selectedTeacher = courses[index]["teacher"] ?? "Unassigned";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Assign Teacher to ${courses[index]['course']}"),
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
                  ),
                  items: teachersList.isEmpty
                      ? [
                          DropdownMenuItem(
                              value: "Unassigned", child: Text("Unassigned"))
                        ]
                      : teachersList
                          .map((teacher) => DropdownMenuItem(
                              value: teacher, child: Text(teacher)))
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTeacher = value;
                      });
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
              onPressed: () async {
                final courseId = courses[index]["CourseID"] ?? "";
                final userId = teacherMap[selectedTeacher] ?? "";

                final (isAssigned, currentTeacherId) =
                    await AdminDashboardController()
                        .checkAssignedCourse(courseId);
                if (isAssigned &&
                    currentTeacherId != null &&
                    userId != currentTeacherId &&
                    userId.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Course is already assigned to another teacher")),
                  );
                  return;
                }

                if (courseId.isEmpty ||
                    (selectedTeacher != "Unassigned" && userId.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Invalid course or teacher ID")),
                  );
                  return;
                }

                final success =
                    await AdminDashboardController().assignTeacherToCourse(
                  userId: userId,
                  courseId: courseId,
                );

                if (success) {
                  courses[index]["teacher"] = selectedTeacher;
                  courses[index]["status"] = selectedTeacher == "Unassigned"
                      ? "Unassigned"
                      : "Assigned";
                  onUpdate();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to assign teacher")),
                  );
                }
              },
              child: const Text("Assign"),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scale();
      },
    );
  }

  static void showAddCourseModal({
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
    required List<String> teachersList,
    required Map<String, String> teacherMap,
    required Function(Map<String, String> newCourse) onAddCourse,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add New Course"),
          content: FormBuilder(
            key: formKey,
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
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter a course name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'category',
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 3,
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
                    items: teachersList.isEmpty
                        ? [
                            DropdownMenuItem(
                                value: "Unassigned", child: Text("Unassigned"))
                          ]
                        : teachersList
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
              onPressed: () async {
                if (formKey.currentState!.saveAndValidate()) {
                  final formData = formKey.currentState!.value;
                  final teacherId = teacherMap[formData['teacher']] ?? '';
                  final courseData = await AdminDashboardController().addCourse(
                    name: formData['course'].toString(),
                    category: formData['category']?.toString(),
                    description: formData['description']?.toString(),
                    userId: teacherId.isEmpty ? null : teacherId,
                  );

                  if (courseData != null) {
                    final newCourse = {
                      'course': courseData['Name'] ?? '',
                      'teacher': formData['teacher'].toString(),
                      'status': formData['teacher'] == 'Unassigned'
                          ? 'Unassigned'
                          : 'Assigned',
                      'category': courseData['Category'] ?? '',
                      'description': courseData['Description'] ?? '',
                      'CourseID': courseData['CourseID'] ?? '',
                    };
                    onAddCourse(newCourse);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add course')),
                    );
                  }
                }
              },
              child: const Text("Add Course"),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scale();
      },
    );
  }
}
