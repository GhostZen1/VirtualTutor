import 'package:path/path.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String description;
  final IconData icon;
  final bool isEnrolled;
  final VoidCallback? onEnroll;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.description,
    required this.icon,
    this.isEnrolled = false,
    this.onEnroll,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Teacher: $teacher",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isEnrolled)
                ElevatedButton(
                  onPressed: onEnroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Enroll'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final String description;
  final int timeLimit;
  final String dueDate;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.dueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Time Limit: ${timeLimit > 0 ? '$timeLimit minutes' : 'No limit'}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                'Due Date: $dueDate',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChapterCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final BuildContext context; // Avoid passing context as a parameter
  final String userId;
  final String courseId;
  final bool isCourseCompleted;
  final VoidCallback onCourseCompleted; // New callback for completion

  const ChapterCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.context,
    required this.userId,
    required this.courseId,
    required this.isCourseCompleted,
    required this.onCourseCompleted, // Added callback
  });

  Future<void> downloadCertificate() async {
    final certUrl =
        '${ApiBase.baseUrl}generateCertificate.php?userId=$userId&courseId=$courseId';
    try {
      // Assuming openMaterial is a utility function to handle downloads
      await openMaterial('certificate', certUrl, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading certificate: $e')),
      );
    }
  }

  Future<void> _finishCourse() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Course'),
        content: const Text(
            'Are you sure you want to mark this course as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.check_circle),
            label: const Text('Confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final CourseController controller = CourseController();
        final success = await controller.finishCourse(
          userId: userId,
          courseId: courseId,
        );

        if (success) {
          onCourseCompleted(); // Trigger callback to update state in parent
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course marked as completed')),
          );
        } else {
          throw Exception('Failed to update course status');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed:
                    isCourseCompleted ? downloadCertificate : _finishCourse,
                icon: Icon(isCourseCompleted
                    ? Icons.file_download
                    : Icons.check_circle),
                label: Text(isCourseCompleted
                    ? 'Download Certificate'
                    : 'Finish Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCourseCompleted ? Colors.blue : Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
