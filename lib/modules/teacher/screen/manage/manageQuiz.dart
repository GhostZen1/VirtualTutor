import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/controller/chapterController.dart';

class ManageQuizScreen extends StatefulWidget {
  final int quizId;
  final String quizTitle;
  final int courseId;

  const ManageQuizScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
    required this.courseId,
  });

  @override
  State<ManageQuizScreen> createState() => _ManageQuizScreenState();
}

class _ManageQuizScreenState extends State<ManageQuizScreen> {
  final ChapterController controller = ChapterController();
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      final fetchedQuestions = await controller.getQuizQuestions(widget.quizId);
      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error loading questions: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  void showQuestionDialog({Map<String, dynamic>? question}) {
    showDialog(
      context: context,
      builder: (context) => AddEditQuestionDialog(
        quizId: widget.quizId,
        question: question,
        onQuestionSaved: loadQuestions,
      ),
    );
  }

  Future<void> deleteQuestion(int questionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text(
            'Are you sure you want to delete this question? This action cannot be undone.'),
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
        final success = await controller.deleteQuestion(questionId);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Question deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          loadQuestions();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete question'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting question: $e'),
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
        title: Text('Manage Quiz - ${widget.quizTitle}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : questions.isEmpty
                        ? const Center(child: Text('No questions available'))
                        : ListView.separated(
                            itemCount: questions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final question = questions[index];
                              return QuizQuestionCard(
                                questionId: question['id'] ?? 0,
                                questionText:
                                    question['question'] ?? 'Untitled Question',
                                type: question['type'] ?? 'Multiple Choice',
                                options: question['options'] != null
                                    ? List<String>.from(
                                        jsonDecode(question['options']))
                                    : [],
                                correctAnswer: question['correct_answer'] ?? '',
                                onEdit: () =>
                                    showQuestionDialog(question: question),
                                onDelete: () =>
                                    deleteQuestion(question['id'] ?? 0),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showQuestionDialog(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddEditQuestionDialog extends StatefulWidget {
  final int quizId;
  final Map<String, dynamic>? question;
  final VoidCallback onQuestionSaved;

  const AddEditQuestionDialog({
    super.key,
    required this.quizId,
    this.question,
    required this.onQuestionSaved,
  });

  @override
  State<AddEditQuestionDialog> createState() => _AddEditQuestionDialogState();
}

class _AddEditQuestionDialogState extends State<AddEditQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _correctAnswerController = TextEditingController();
  String _type = 'Multiple Choice';
  List<String> _options = ['', '', '', ''];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.question != null;
    if (_isEditing) {
      _questionController.text = widget.question!['question'] ?? '';
      _type = widget.question!['type'] ?? 'Multiple Choice';
      _correctAnswerController.text = widget.question!['correct_answer'] ?? '';
      _options = widget.question!['options'] != null
          ? List<String>.from(jsonDecode(widget.question!['options']))
          : ['', '', '', ''];
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _correctAnswerController.dispose();
    super.dispose();
  }

  Future<void> saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      try {
        final questionData = {
          'question': _questionController.text,
          'type': _type,
          'options': _type != 'Short Answer' ? _options : null,
          'correct_answer': _correctAnswerController.text,
        };

        bool success;
        if (_isEditing) {
          questionData['question_id'] = widget.question!['id'];
          success = await ChapterController()
              .updateQuestion(widget.quizId, questionData);
        } else {
          success = await ChapterController()
              .addQuestion(widget.quizId, questionData);
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditing
                  ? 'Question updated successfully'
                  : 'Question added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onQuestionSaved();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save question'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error saving question: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Question' : 'Add Question'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Question is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Question Type'),
                items: ['Multiple Choice', 'True/False', 'Short Answer']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                    if (_type == 'True/False') {
                      _options = ['True', 'False'];
                    } else if (_type == 'Short Answer') {
                      _options = [];
                    } else {
                      _options = ['', '', '', ''];
                    }
                  });
                },
              ),
              if (_type != 'Short Answer') ...[
                const SizedBox(height: 16),
                const Text('Options',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...List.generate(
                  _type == 'True/False' ? 2 : 4,
                  (index) => TextFormField(
                    initialValue: _options[index],
                    decoration:
                        InputDecoration(labelText: 'Option ${index + 1}'),
                    onChanged: (value) => _options[index] = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Option is required' : null,
                    enabled: _type != 'True/False',
                  ),
                ),
              ],
              TextFormField(
                controller: _correctAnswerController,
                decoration: const InputDecoration(labelText: 'Correct Answer'),
                validator: (value) =>
                    value!.isEmpty ? 'Correct answer is required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: saveQuestion,
          child: Text(_isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}

class QuizQuestionCard extends StatelessWidget {
  final int questionId;
  final String questionText;
  final String type;
  final List<String> options;
  final String correctAnswer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuizQuestionCard({
    super.key,
    required this.questionId,
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Type: $type'),
            const SizedBox(height: 8),
            if (type == 'Multiple Choice' && options.isNotEmpty) ...[
              const Text('Options:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(options.length, (index) {
                  String label = String.fromCharCode(65 + index);
                  return Text('$label. ${options[index]}');
                }),
              ),
              const SizedBox(height: 8),
              Text('Correct Answer: $correctAnswer'),
            ] else if (type == 'True/False') ...[
              Text('Answer: $correctAnswer'),
            ] else if (type == 'Short Answer') ...[
              const Text('Correct Answer:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(correctAnswer),
            ],
          ],
        ),
      ),
    );
  }
}
