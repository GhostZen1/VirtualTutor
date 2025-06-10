import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/controller/chapterController.dart';
import 'package:tosl_operation/modules/teacher/screen/manage/manageMaterial.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChapters();
  }

  // Load chapters for the course
  Future<void> loadChapters() async {
    try {
      final fetchedChapters = await controller.fetchChapters(widget.courseId);
      setState(() {
        chapters = fetchedChapters;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading chapters: $e')),
      );
    }
  }

  // Navigate to chapter materials management
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

  // Show add chapter dialog
  void showAddChapterDialog() {
    showDialog(
      context: context,
      builder: (context) => AddChapterDialog(
        courseId: widget.courseId,
        onChapterAdded: loadChapters,
      ),
    );
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

  // Delete chapter
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
          loadChapters(); // Refresh the list
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
}

class ChapterManagementCard extends StatelessWidget {
  final int chapterId;
  final String title;
  final String description;
  final int chapterOrder;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ChapterManagementCard({
    super.key,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.chapterOrder,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chapter $chapterOrder',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete Chapter',
                  ),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 16,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Manage Materials',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddChapterDialog extends StatefulWidget {
  final int courseId;
  final VoidCallback onChapterAdded;

  const AddChapterDialog({
    super.key,
    required this.courseId,
    required this.onChapterAdded,
  });

  @override
  State<AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _orderController = TextEditingController();
  final ChapterController controller = ChapterController();
  bool isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> addChapter() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a chapter title')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await controller.addChapter(
        courseId: widget.courseId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        content: _contentController.text.trim(),
      );

      if (success) {
        Navigator.pop(context);
        widget.onChapterAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chapter added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add chapter'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding chapter: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Chapter'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Chapter Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // TextField(
            //   controller: _orderController,
            //   decoration: const InputDecoration(
            //     labelText: 'Chapter Order',
            //     border: OutlineInputBorder(),
            //   ),
            //   keyboardType: TextInputType.number,
            // ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : addChapter,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Add Chapter'),
        ),
      ],
    );
  }
}
