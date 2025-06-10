import 'package:tosl_operation/modules/global.dart';
import 'package:get/get.dart';
import 'package:tosl_operation/modules/teacher/controller/courseController.dart';

class TrackStudentProgressScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const TrackStudentProgressScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<TrackStudentProgressScreen> createState() =>
      _TrackStudentProgressScreenState();
}

class _TrackStudentProgressScreenState
    extends State<TrackStudentProgressScreen> {
  final ProgressController controller = Get.put(ProgressController());
  String searchQuery = '';
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    controller.fetchProgressData(); // Fetch all data (not filtered)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Progress")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Extract unique course names
        final courseList = controller.progressData
            .map((e) => e['course'] as String)
            .toSet()
            .toList();

        // Apply filters
        final filteredData = controller.progressData.where((entry) {
          final matchStudent = entry['student']
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
          final matchCourse =
              selectedCourse == null || entry['course'] == selectedCourse;
          return matchStudent && matchCourse;
        }).toList();

        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // 🔍 Search field
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
                    // 🔽 Course dropdown
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
                          ...courseList.map((course) => DropdownMenuItem(
                                value: course,
                                child: Text(course,
                                    overflow: TextOverflow.ellipsis),
                              ))
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
            Expanded(
              child: SingleChildScrollView(
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
            ),
          ],
        );
      }),
    );
  }
}
