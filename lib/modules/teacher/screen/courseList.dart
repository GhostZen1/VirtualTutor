import 'package:get/get.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/controller/courseController.dart';

class CourseListScreen extends StatelessWidget {
  final Function(String courseTitle, String courseId)
      onSelectCourse; // Updated to include courseId
  final String currentUserId;

  const CourseListScreen({
    super.key,
    required this.onSelectCourse,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final CourseController controller =
        Get.put(CourseController(currentUserId: currentUserId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => controller.searchCourses(value),
              decoration: InputDecoration(
                hintText: "Search your courses...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: controller.filteredCourseList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final course = controller.filteredCourseList[index];
                        return GestureDetector(
                          onTap: () {
                            onSelectCourse(
                                course['title'], course['courseId'].toString());
                          },
                          child: CourseProgressCard(
                            title: course['title'],
                            ttlEnroll: course['total'],
                            icon: Icons.code,
                          ),
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseProgressCard extends StatelessWidget {
  final String title;
  final String ttlEnroll;
  final IconData icon;

  const CourseProgressCard({
    super.key,
    required this.title,
    required this.ttlEnroll,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Total Student Enrolled: $ttlEnroll",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
