import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/component/card.dart';
import 'package:tosl_operation/modules/teacher/controller/courseController.dart';
import 'package:tosl_operation/modules/teacher/controller/teacherController.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/viewStudentReview.dart';

class TeacherHomeScreen extends StatefulWidget {
  final int userId;

  const TeacherHomeScreen({super.key, required this.userId});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final TeacherController teacherController = TeacherController();
  final ProgressController progressController = Get.put(ProgressController());

  String teacherName = "Dr. null";
  bool isLoading = true;
  String? errorMessage;
  UserModel? teacherData;
  String searchQuery = '';
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
    progressController.fetchProgressData();
  }

  Future<void> _loadTeacherData() async {
    try {
      final data =
          await TeacherController.fetchTeacherById(widget.userId.toString());
      setState(() {
        teacherData = data;
        teacherName = data.username;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load teacher data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CourseController controller =
        Get.put(CourseController(currentUserId: widget.userId.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $teacherName",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                isLoading
                    ? "Loading your data..."
                    : errorMessage != null
                        ? "Using cached data"
                        : "Welcome back!",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          errorMessage != null ? Colors.orange.shade600 : null,
                    ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: [
                  // filterChip(
                  //   context,
                  //   icon: Icons.show_chart,
                  //   label: "Student Progress",
                  //   color: Colors.blue,
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             const TrackStudentProgressScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  filterChip(
                    context,
                    icon: Icons.feedback,
                    label: "Feedback",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewStudentReviewScreen(
                            teacherId: widget.userId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Student Progress",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final courseList = progressController.progressData
                    .map((e) => e['course'] as String)
                    .toSet()
                    .toList();

                final filteredData =
                    progressController.progressData.where((entry) {
                  final matchStudent = entry['student']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                  final matchCourse = selectedCourse == null ||
                      entry['course'] == selectedCourse;
                  return matchStudent && matchCourse;
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: "Search Student",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 250,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: "Filter by Course",
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedCourse,
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text("All Courses"),
                                  ),
                                  ...courseList.map(
                                    (course) => DropdownMenuItem(
                                      value: course,
                                      child: Text(course,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() => selectedCourse = value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Student")),
                          DataColumn(label: Text("Course")),
                          DataColumn(label: Text("Progress (%)")),
                          DataColumn(label: Text("Enrollment Date")),
                          DataColumn(label: Text("Status")),
                        ],
                        rows: filteredData.map((entry) {
                          return DataRow(cells: [
                            DataCell(Text(entry['student'])),
                            DataCell(Text(entry['course'])),
                            DataCell(Text("${entry['progress']}%")),
                            DataCell(Text(entry['enrollmentDate'])),
                            DataCell(Text(entry['completionStatus'])),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
