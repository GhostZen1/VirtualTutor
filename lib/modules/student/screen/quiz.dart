import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final String quizDescription;
  final int timeLimit;
  final String userId;

  const QuizScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
    required this.quizDescription,
    required this.timeLimit,
    required this.userId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  Map<String, String> userAnswers = {};
  bool isLoading = true;
  bool isSubmitted = false; // NEW
  int timeRemaining = 0;
  Timer? timer;
  Map<String, dynamic>? quizResult;
  String? marks;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    if (widget.timeLimit > 0) {
      timeRemaining = widget.timeLimit * 60;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeRemaining--;
          if (timeRemaining <= 0) {
            timer.cancel();
            submitQuiz();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadQuestions() async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiBase.baseUrl}fetchQuizQuestions.php?quiz_id=${widget.quizId}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            questions = List<Map<String, dynamic>>.from(data['questions']);
            marks = data['totalQuestions'].toString();
            isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load questions');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  Future<void> submitQuiz() async {
    if (isSubmitted) return;

    try {
      final controller = CourseController();
      final result = await controller.submitQuiz(
        userId: widget.userId,
        quizId: widget.quizId,
        answers: userAnswers,
      );

      if (mounted) {
        setState(() {
          quizResult = result;
          isSubmitted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Quiz submitted! Score: ${result['totalMarks']}/${result['totalQuestions']} (${result['percentage']}%)',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting quiz: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quizTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.quizDescription),
                      const SizedBox(height: 8),
                      if (widget.timeLimit > 0 && !isSubmitted)
                        Text(
                          'Time Remaining: ${timeRemaining ~/ 60}:${(timeRemaining % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (quizResult != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Score: ${quizResult!['totalMarks']}/$marks',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Percentage: ${quizResult!['percentage']}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : questions.isEmpty
                        ? const Center(child: Text('No questions available'))
                        : ListView.builder(
                            itemCount: questions.length + 1,
                            itemBuilder: (context, index) {
                              if (index == questions.length) {
                                return ElevatedButton(
                                  onPressed: isSubmitted ? null : submitQuiz,
                                  child: const Text('Submit Quiz'),
                                );
                              }
                              final question = questions[index];
                              return QuestionCard(
                                question: question,
                                selectedAnswer:
                                    userAnswers[question['id'].toString()],
                                isSubmitted: isSubmitted,
                                onAnswerSelected: (answer) {
                                  setState(() {
                                    userAnswers[question['id'].toString()] =
                                        answer;
                                  });
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final String? selectedAnswer;
  final bool isSubmitted;
  final Function(String) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.isSubmitted,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final type = question['type'] ?? 'Multiple Choice';
    final options = question['options'] != null
        ? List<String>.from(json.decode(question['options']))
        : [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'] ?? 'No question',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (type == 'Multiple Choice' && options.isNotEmpty)
              ...options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedAnswer,
                  onChanged: isSubmitted
                      ? null
                      : (value) {
                          if (value != null) {
                            onAnswerSelected(value);
                          }
                        },
                );
              }),
            if (type == 'True/False')
              ...['True', 'False'].map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedAnswer,
                  onChanged: isSubmitted
                      ? null
                      : (value) {
                          if (value != null) {
                            onAnswerSelected(value);
                          }
                        },
                );
              }),
            if (type == 'Short Answer')
              TextField(
                enabled: !isSubmitted,
                onChanged: onAnswerSelected,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Answer',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
