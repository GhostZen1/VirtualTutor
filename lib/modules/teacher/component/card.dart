import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/controller/chapterController.dart';

Widget filterChip(
  BuildContext context, {
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 10),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
  );
}

Widget courseCard({
  required String title,
  required String description,
  required Color color,
}) {
  return Container(
    width: 180,
    margin: const EdgeInsets.only(right: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  );
}

Widget moduleCard(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    ),
  );
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
                          style: const TextStyle(
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
                  const Icon(
                    Icons.play_circle_outline,
                    size: 16,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 4),
                  const Text(
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

  final _quizTitleController = TextEditingController();
  final _quizDescriptionController = TextEditingController();
  final _questionsController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final ChapterController controller = ChapterController();

  List<PlatformFile> _selectedPDFs = [];
  bool isLoading = false;
  String selectedType = 'chapter';
  String selectedQuizType = 'Multiple Choice';
  DateTime? selectedDueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _orderController.dispose();
    _quizTitleController.dispose();
    _quizDescriptionController.dispose();
    _questionsController.dispose();
    _dueDateController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  Future<void> _pickPDFs() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _selectedPDFs = result.files;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking PDFs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Future<void> addQuiz() async {
    if (_quizTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a quiz title')),
      );
      return;
    }

    if (_questionsController.text.trim().isEmpty ||
        int.tryParse(_questionsController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid number of questions')),
      );
      return;
    }

    if (selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date')),
      );
      return;
    }

    if (_timeLimitController.text.trim().isEmpty ||
        int.tryParse(_timeLimitController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid time limit')),
      );
      return;
    }

    if (_selectedPDFs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one PDF')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final generatedQuestions = await controller.generateQuizFromPDF(
        courseId: widget.courseId,
        pdfFiles: _selectedPDFs,
        questionCount: int.parse(_questionsController.text.trim()),
        quizType: selectedQuizType,
        context: context,
      );

      if (generatedQuestions == null) {
        throw Exception('Failed to generate quiz from PDFs');
      }

      final success = await controller.addQuiz(
        courseId: widget.courseId,
        title: _quizTitleController.text.trim(),
        description: _quizDescriptionController.text.trim(),
        questionCount: int.parse(_questionsController.text.trim()),
        quizType: selectedQuizType,
        dueDate: selectedDueDate!,
        timeLimit: int.parse(_timeLimitController.text.trim()),
        questions: generatedQuestions, // Pass generated questions
      );

      if (success) {
        Navigator.pop(context);
        widget.onChapterAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create quiz'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating quiz: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
        _dueDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          selectedType == 'chapter' ? 'Add New Chapter' : 'Create New Quiz'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = 'chapter';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == 'chapter'
                          ? Colors.deepPurple
                          : Colors.grey[300],
                      foregroundColor: selectedType == 'chapter'
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: const Text('Chapter'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedType = 'quiz';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedType == 'quiz'
                          ? Colors.deepPurple
                          : Colors.grey[300],
                      foregroundColor:
                          selectedType == 'quiz' ? Colors.white : Colors.black,
                    ),
                    child: const Text('Quiz'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chapter form
            if (selectedType == 'chapter') ...[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Chapter Title',
                  border: OutlineInputBorder(),
                ),
              ),
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

            // Quiz form
            if (selectedType == 'quiz') ...[
              TextField(
                controller: _quizTitleController,
                decoration: const InputDecoration(
                  labelText: 'Quiz Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quizDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Quiz Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _questionsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedQuizType,
                decoration: const InputDecoration(
                  labelText: 'Quiz Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Multiple Choice', 'True/False', 'Short Answer']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedQuizType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _timeLimitController,
                decoration: const InputDecoration(
                  labelText: 'Time Limit (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickPDFs,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Upload PDFs for Quiz Generation'),
              ),
              if (_selectedPDFs.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Selected PDFs: ${_selectedPDFs.length}',
                  style: const TextStyle(fontSize: 14),
                ),
                ..._selectedPDFs
                    .map((file) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            file.name,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : (selectedType == 'chapter' ? addChapter : addQuiz),
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
              : Text(selectedType == 'chapter' ? 'Add Chapter' : 'Create Quiz'),
        ),
      ],
    );
  }
}

class QuizManagementCard extends StatelessWidget {
  final int quizId;
  final String title;
  final String description;
  final int questionCount;
  final String quizType;
  final String dueDate;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const QuizManagementCard({
    super.key,
    required this.quizId,
    required this.title,
    required this.description,
    required this.questionCount,
    required this.quizType,
    required this.dueDate,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description.isEmpty ? 'No description' : description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Questions: $questionCount | Type: $quizType | Due: $dueDate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
