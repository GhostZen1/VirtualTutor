import 'package:flutter/material.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/component/card.dart';
import 'package:tosl_operation/modules/teacher/controller/chapterController.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageMaterial.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageQuiz.dart';

class ManageChapterScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  final String userId;

  const ManageChapterScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.userId,
  });

  @override
  State<ManageChapterScreen> createState() => _ManageChapterScreenState();
}

class _ManageChapterScreenState extends State<ManageChapterScreen> {
  final ChapterController controller = ChapterController();
  List<Map<String, dynamic>> chapters = [];
  List<Map<String, dynamic>> quizzes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChaptersAndQuizzes();
  }

  Future<void> loadChaptersAndQuizzes() async {
    try {
      final fetchedChapters = await controller.fetchChapters(widget.courseId);
      final fetchedQuizzes =
          await controller.getQuizzesByCourse(widget.courseId);
      setState(() {
        chapters = fetchedChapters;
        quizzes = fetchedQuizzes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  void navigateToChapterMaterials(int chapterId, String chapterTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageChapterMaterialsScreen(
          chapterId: chapterId,
          chapterTitle: chapterTitle,
        ),
      ),
    );
  }

  void navigateToQuizManagement(int quizId, String quizTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageQuizScreen(
          quizId: quizId,
          quizTitle: quizTitle,
          courseId: widget.courseId,
        ),
      ),
    );
  }

  void showAddChapterDialog() {
    showDialog(
      context: context,
      builder: (context) => AddChapterDialog(
        courseId: widget.courseId,
        onChapterAdded: loadChaptersAndQuizzes,
      ),
    );
  }

  Future<void> deleteChapter(int chapterId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chapter'),
        content: const Text(
            'Are you sure you want to delete this chapter? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await controller.deleteChapter(chapterId);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chapter deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          loadChaptersAndQuizzes();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete chapter'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting chapter: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteQuiz(int quizId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text(
            'Are you sure you want to delete this quiz? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await controller.deleteQuiz(quizId);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quiz deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          loadChaptersAndQuizzes();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete quiz'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting quiz: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Chapters - ${widget.courseTitle}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chapters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 1,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : chapters.isEmpty
                        ? const Center(child: Text('No chapters available'))
                        : ListView.separated(
                            itemCount: chapters.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final chapter = chapters[index];
                              return ChapterManagementCard(
                                chapterId: chapter['id'] ?? 0,
                                title: chapter['title'] ?? 'Untitled Chapter',
                                description: chapter['description'] ?? '',
                                chapterOrder: chapter['chapter_order'] ?? 0,
                                onTap: () => navigateToChapterMaterials(
                                  chapter['id'] ?? 0,
                                  chapter['title'] ?? 'Untitled Chapter',
                                ),
                                onDelete: () =>
                                    deleteChapter(chapter['id'] ?? 0),
                              );
                            },
                          ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quizzes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 1,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : quizzes.isEmpty
                        ? const Center(child: Text('No quizzes available'))
                        : ListView.separated(
                            itemCount: quizzes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final quiz = quizzes[index];
                              return QuizManagementCard(
                                quizId: quiz['id'] ?? 0,
                                title: quiz['title'] ?? 'Untitled Quiz',
                                description: quiz['description'] ?? '',
                                questionCount: quiz['question_count'] ?? 0,
                                quizType:
                                    quiz['quiz_type'] ?? 'Multiple Choice',
                                dueDate: quiz['due_date'] ?? '',
                                onTap: () => navigateToQuizManagement(
                                  quiz['id'] ?? 0,
                                  quiz['title'] ?? 'Untitled Quiz',
                                ),
                                onDelete: () => deleteQuiz(quiz['id'] ?? 0),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddChapterDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
