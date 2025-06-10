import 'package:tosl_operation/modules/teacher/controller/teacherController.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageChapter.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/analyzeStudentPerformance.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageLearningMaterial.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageQuiz.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/trackStudentProgress.dart';
import 'package:tosl_operation/modules/teacher/screen/courseList.dart';
import 'package:tosl_operation/modules/teacher/component/card.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/viewStudentReview.dart';

class TeacherHomeScreen extends StatefulWidget {
  final int userId;

  const TeacherHomeScreen({super.key, required this.userId});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final TeacherController teacherController = TeacherController();

  String teacherName = "Dr. null";
  bool isLoading = true;
  String? errorMessage;
  UserModel? teacherData;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    try {
      final data =
          await TeacherController.fetchTeacherById(widget.userId.toString());
      setState(() {
        teacherData = data;
        teacherName = data.username ?? "Dr. null";
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load teacher data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, $teacherName",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        isLoading
                            ? "Loading your data..."
                            : errorMessage != null
                                ? "Using cached data"
                                : "Welcome back!",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: errorMessage != null
                                  ? Colors.orange.shade600
                                  : null,
                            ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  filterChip(
                    context,
                    icon: Icons.feedback,
                    label: "Feedback",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewStudentReviewScreen(),
                        ),
                      );
                    },
                  ),
                  filterChip(
                    context,
                    icon: Icons.bar_chart,
                    label: "Analytics",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnalyzeStudentPerformanceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
              const SizedBox(height: 15),
              Text(
                "Teacher Modules",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(duration: 500.ms, delay: 1000.ms),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  moduleCard(
                    context,
                    icon: Icons.people,
                    label: "View Student Progress",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseListScreen(
                            currentUserId: widget.userId.toString(),
                            onSelectCourse: (courseTitle, courseId) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TrackStudentProgressScreen(
                                    courseTitle: courseTitle,
                                    courseId: courseId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  // moduleCard(
                  //   context,
                  //   icon: Icons.book,
                  //   label: "Manage Chapters",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => CourseListScreen(
                  //           currentUserId: widget.userId.toString(),
                  //           onSelectCourse: (courseTitle, courseId) {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => ManageChaptersScreen(
                  //                   courseTitle: courseTitle,
                  //                   courseId: courseId,
                  //                   userId: widget.userId.toString(),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  moduleCard(
                    context,
                    icon: Icons.quiz,
                    label: "Manage Quiz / Activity",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageQuizScreen(),
                        ),
                      );
                    },
                  ),
                  moduleCard(
                    context,
                    icon: Icons.show_chart,
                    label: "Track Student Progress",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseListScreen(
                            currentUserId: widget.userId.toString(),
                            onSelectCourse: (courseTitle, courseId) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TrackStudentProgressScreen(
                                    courseTitle: courseTitle,
                                    courseId: courseId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
