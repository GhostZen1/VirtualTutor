import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/admin/controller/adminController.dart';
import 'package:tosl_operation/modules/admin/component/manageCourseHelper.dart';

class ManageCourseScreen extends StatefulWidget {
  const ManageCourseScreen({super.key});

  @override
  ManageCourseScreenState createState() => ManageCourseScreenState();
}

class ManageCourseScreenState extends State<ManageCourseScreen> {
  List<Map<String, String>> courses = [];
  bool isLoading = true;
  List<String> teachersList = [];
  Map<String, String> teacherMap = {};

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final (fetchedTeachersList, fetchedTeacherMap) =
          await ManageCourseHelper.fetchTeachersAndMap();
      final fetchedCourses =
          await AdminDashboardController().fetchListCourseAvailable();

      print("TeachersList: $fetchedTeachersList");
      print("TeacherMap: $fetchedTeacherMap");
      print("Fetched Courses: $fetchedCourses");

      List<Map<String, String>> updatedCourses = [];
      for (var course in fetchedCourses) {
        final courseId = course["CourseID"] ?? "";
        print("Processing course: ${course["Name"]} (ID: $courseId)");

        final (isAssigned, teacherId) =
            await AdminDashboardController().checkAssignedCourse(courseId);
        print("Course $courseId: isAssigned=$isAssigned, teacherId=$teacherId");

        String teacherName = "Unassigned";
        String status = isAssigned ? "Assigned" : "Unassigned";
        if (isAssigned && teacherId != null) {
          teacherName = fetchedTeacherMap.entries.firstWhere(
            (entry) => entry.value == teacherId,
            orElse: () {
              print("No teacher found for teacherId: $teacherId");
              return const MapEntry("Unassigned", "");
            },
          ).key;
        }

        updatedCourses.add({
          "course": course["Name"] ?? "Unknown",
          "teacher": teacherName,
          "status": status,
          "category": course["Category"] ?? "",
          "description": course["Description"] ?? "",
          "CourseID": courseId,
        });
        print(
            "Added course: ${course["Name"]}, teacher: $teacherName, status: $status");
      }

      setState(() {
        teachersList = fetchedTeachersList;
        teacherMap = fetchedTeacherMap;
        courses = updatedCourses;
        isLoading = false;
      });
    } catch (e) {
      print("Error in _loadInitialData: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Course"),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : courses.isEmpty
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
                    print(
                        "Rendering course: ${course["course"]}, status: ${course["status"]}");
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
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
                              ManageCourseHelper.showTeacherAssignmentModal(
                            context,
                            index,
                            courses,
                            teachersList,
                            teacherMap,
                            () => setState(() {}),
                          ),
                        ),
                        onTap: () =>
                            ManageCourseHelper.showTeacherAssignmentModal(
                          context,
                          index,
                          courses,
                          teachersList,
                          teacherMap,
                          () => setState(() {}),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(delay: (index * 100).ms);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ManageCourseHelper.showAddCourseModal(
          context: context,
          formKey: _formKey,
          teachersList: teachersList,
          teacherMap: teacherMap,
          onAddCourse: (newCourse) {
            setState(() {
              courses.add(newCourse);
              _loadInitialData(); // Refresh course list
            });
          },
        ),
        tooltip: 'Add Course',
        child: const Icon(Icons.add),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
