import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/component/card.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';
import 'package:tosl_operation/modules/student/screen/material.dart';
import 'package:tosl_operation/modules/student/screen/quiz.dart';

class ChapterScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String userId;

  const ChapterScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.userId,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final CourseController controller = CourseController();
  List<Map<String, dynamic>> chapters = [];
  List<Map<String, dynamic>> quizzes = [];
  bool isLoading = true;
  String selectedSection = 'Chapter'; // Default section
  final List<String> sections = ['Chapter', 'Quiz', 'Teacher Review'];
  int? teacherId;
  bool isCourseCompleted = false;

  @override
  void initState() {
    super.initState();
    loadContent();
    loadTeacherId();
    loadCourseStatus();
  }

  Future<void> loadContent() async {
    setState(() => isLoading = true);
    try {
      if (selectedSection == 'Chapter') {
        final fetchedChapters =
            await controller.fetchCourseChapters(widget.courseId);
        setState(() {
          chapters = fetchedChapters;
          quizzes = [];
        });
      } else if (selectedSection == 'Quiz') {
        final fetchedQuizzes =
            await controller.fetchCourseQuizzes(widget.courseId);
        setState(() {
          quizzes = fetchedQuizzes;
          chapters = [];
        });
      } else {
        setState(() {
          chapters = [];
          quizzes = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading $selectedSection: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loadTeacherId() async {
    try {
      final id = await controller.getTeacherId(courseId: widget.courseId);
      setState(() {
        teacherId = id;
      });
    } catch (e) {
      print('Error loading teacher ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
        backgroundColor: Colors.deepPurple,
        actions: [
          DropdownButton<String>(
            value: selectedSection,
            items: sections
                .map((section) => DropdownMenuItem(
                      value: section,
                      child: Text(section),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSection = value!;
                loadContent();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : selectedSection == 'Chapter'
                        ? _buildChapterList()
                        : selectedSection == 'Quiz'
                            ? _buildQuizList()
                            : _buildTeacherReview(),
              ),
              const SizedBox(height: 16),
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
              )
            ],
          ),
        ),
      ),
    );
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
        final success = await controller.finishCourse(
          userId: widget.userId,
          courseId: widget.courseId,
        );

        if (success) {
          setState(() {
            isCourseCompleted = true;
          });
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

  Future<void> loadCourseStatus() async {
    try {
      final status = await controller.fetchEnrollmentStatus(
        userId: widget.userId,
        courseId: widget.courseId,
      );
      setState(() {
        setState(() {
          isCourseCompleted = (status?.toLowerCase() == 'complete');
        });
      });
    } catch (e) {
      print('Error fetching course status: $e');
    }
  }

  Future<void> downloadCertificate() async {
    final certUrl =
        '${ApiBase.baseUrl}generateCertificate.php?userId=${widget.userId}&courseId=${widget.courseId}';
    await openMaterial('certificate', certUrl, context);
  }

  Widget _buildChapterList() {
    return chapters.isEmpty
        ? const Center(child: Text('No chapters available'))
        : ListView.separated(
            itemCount: chapters.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return ChapterCard(
                title: chapter['title'] ?? 'Untitled Chapter',
                description: chapter['description'] ?? 'No description',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialScreen(
                        chapterId: chapter['id'],
                        chapterTitle: chapter['title'],
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              );
            },
          );
  }

  Widget _buildQuizList() {
    return quizzes.isEmpty
        ? const Center(child: Text('No quizzes available'))
        : ListView.separated(
            itemCount: quizzes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return QuizCard(
                title: quiz['title'] ?? 'Untitled Quiz',
                description: quiz['description'] ?? 'No description',
                timeLimit: quiz['time_limit'] ?? 0,
                dueDate: quiz['due_date'] ?? 'No due date',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Start Quiz: ${quiz['title']}'),
                      content: const Text('Do you want to answer this quiz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  quizId: quiz['id'].toString(),
                                  quizTitle: quiz['title'],
                                  quizDescription: quiz['description'],
                                  timeLimit: quiz['time_limit'],
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
  }

  Widget _buildTeacherReview() {
    final ratingController = TextEditingController();
    final commentController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Teacher',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              ratingController.text = rating.toInt().toString();
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              try {
                final success = await controller.submitFeedback(
                  studentId: widget.userId,
                  teacherId: teacherId.toString(),
                  courseId: widget.courseId,
                  rating: int.parse(ratingController.text),
                  comment: commentController.text,
                );
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback submitted')),
                  );
                  ratingController.clear();
                  commentController.clear();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error submitting feedback: $e')),
                );
              }
            },
            child: const Text('Submit Feedback'),
          ),
        ],
      ),
    );
  }
}
