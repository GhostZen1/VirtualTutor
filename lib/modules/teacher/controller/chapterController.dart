import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tosl_operation/modules/global.dart';

class ChapterController {
  // #region Chapter
  Future<List<Map<String, dynamic>>> fetchChapters(int courseId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}fetchChapters.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'course_id': courseId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['chapters']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch chapters');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> addChapter({
    required int courseId,
    required String title,
    required String description,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}addChapter.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'course_id': courseId,
          'title': title,
          'description': description,
          'content': content,
          'is_free': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteChapter(int chapterId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}deleteChapter.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chapter_id': chapterId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // #endregion
  // #region Chapter Material
  Future<List<Map<String, dynamic>>> fetchChapterMaterials(
      int chapterId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}fetchChapterMaterials.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chapter_id': chapterId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['materials']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch materials');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> addMaterial({
    required int chapterId,
    required String title,
    required String type,
    required String url,
    required String description,
    required String fileSize,
    required bool isDownloadable,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}addMaterial.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chapter_id': chapterId,
          'title': title,
          'type': type,
          'url': url,
          'description': description,
          'file_size': fileSize,
          'is_downloadable': isDownloadable,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteMaterial(int materialId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}deleteMaterial.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'material_id': materialId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateMaterialAvailability(
      int materialId, bool isAvailable) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}updateMaterialAvailability.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'material_id': materialId,
          'is_available': isAvailable,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // #endregion
  // #region Quiz
  Future<bool> addQuiz({
    required int courseId,
    required String title,
    required String description,
    required int questionCount,
    required String quizType,
    required DateTime dueDate,
    required int timeLimit,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'create_quiz',
          'course_id': courseId,
          'title': title,
          'description': description,
          'question_count': questionCount,
          'quiz_type': quizType,
          'due_date':
              '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
          'time_limit': timeLimit,
          'questions': questions,
        }),
      );

      print('Request URL: ${response.request?.url}');
      print('Request Body: ${json.encode({
            'action': 'create_quiz',
            'course_id': courseId,
            'title': title,
            'description': description,
            'question_count': questionCount,
            'quiz_type': quizType,
            'due_date':
                '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
            'time_limit': timeLimit,
            'questions': questions,
          })}');
      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            print('Quiz created successfully with ID: ${data['quiz_id']}');
            return true;
          } else {
            print(
                'Quiz creation failed: ${data['message'] ?? 'Unknown error'}');
            return false;
          }
        } catch (e) {
          print('JSON decode error: $e');
          print('Response body: ${response.body}');
          return false;
        }
      } else {
        print('Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception in addQuiz: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> generateQuizFromPDF({
    required int courseId,
    required List<dynamic> pdfFiles,
    required int questionCount,
    required String quizType,
    required BuildContext context,
  }) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      StringBuffer textContent = StringBuffer();

      // Read and extract text from each PDF file
      for (dynamic pdfFile in pdfFiles) {
        try {
          File file;
          if (pdfFile is File) {
            file = pdfFile;
          } else if (pdfFile is String) {
            file = File(pdfFile);
          } else if (pdfFile is PlatformFile) {
            file = File(pdfFile.path!);
          } else {
            throw Exception('Unsupported file type: ${pdfFile.runtimeType}');
          }

          final List<int> bytes = file.readAsBytesSync();
          final PdfDocument document = PdfDocument(inputBytes: bytes);
          final PdfTextExtractor extractor = PdfTextExtractor(document);

          for (int i = 0; i < document.pages.count; i++) {
            final String pageText = extractor.extractText(
              startPageIndex: i,
              endPageIndex: i,
            );
            if (pageText.trim().isNotEmpty) {
              textContent.writeln(pageText.trim());
            }
          }

          document.dispose();
        } catch (e) {
          print('Error extracting text from PDF: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error reading PDF: $e'),
              backgroundColor: Colors.orange,
            ),
          );
          continue;
        }
      }

      Navigator.pop(context); // Close loading

      // Get extracted content
      String finalContent = textContent.toString().trim();

      // Trim to only start from "Learning Outcome"
      String cleanedContent = finalContent;
      final learningIndex =
          finalContent.toLowerCase().indexOf('learning outcome');
      if (learningIndex != -1) {
        cleanedContent = finalContent.substring(learningIndex).trim();
      }

      // Fallback if content is empty
      if (cleanedContent.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No text content could be extracted from the PDFs'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Send to backend
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}generateQuizfromText.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'course_id': courseId,
          'question_count': questionCount,
          'quiz_type': quizType,
          'text_content': cleanedContent.isEmpty
              ? 'No content extracted from PDFs, generating sample questions.'
              : cleanedContent,
        }),
      );

      print('Request URL: ${response.request?.url}');
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['questions'] != null) {
          List<Map<String, dynamic>> questions =
              List<Map<String, dynamic>>.from(data['questions']);

          for (var q in questions) {
            if (!q.containsKey('question') ||
                !q.containsKey('type') ||
                !q.containsKey('correct_answer')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invalid question data from server'),
                  backgroundColor: Colors.red,
                ),
              );
              return null;
            }

            if (q['type'] == 'Multiple Choice' && !q.containsKey('options')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Missing options for Multiple Choice'),
                  backgroundColor: Colors.red,
                ),
              );
              return null;
            }
          }

          return questions;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to generate quiz: ${data['message'] ?? 'Unknown error'}',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return null;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      Navigator.pop(context);
      print('Exception in generateQuizFromPDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating quiz: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getQuizzesByCourse(int courseId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'get_quizzes',
          'course_id': courseId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['quizzes']);
        }
      }
      return [];
    } catch (e) {
      print('Exception in getQuizzesByCourse: $e');
      return [];
    }
  }

  Future<bool> deleteQuiz(int quizId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'delete_quiz',
          'quiz_id': quizId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Exception in deleteQuiz: $e');
      return false;
    }
  }

  // #endregion
  // #region quiz questions
  Future<List<Map<String, dynamic>>> getQuizQuestions(int quizId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'get_questions',
          'quiz_id': quizId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['questions']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching questions: $e');
      throw e;
    }
  }

  Future<bool> addQuestion(
      int quizId, Map<String, dynamic> questionData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'add_question',
          'quiz_id': quizId,
          'question': questionData['question'],
          'type': questionData['type'],
          'options': questionData['options'],
          'correct_answer': questionData['correct_answer'],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error adding question: $e');
      throw e;
    }
  }

  Future<bool> updateQuestion(
      int quizId, Map<String, dynamic> questionData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'update_question',
          'question_id': questionData['question_id'],
          'question': questionData['question'],
          'type': questionData['type'],
          'options': questionData['options'],
          'correct_answer': questionData['correct_answer'],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error updating question: $e');
      throw e;
    }
  }

  Future<bool> deleteQuestion(int questionId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}quiz.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'delete_question',
          'question_id': questionId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error deleting question: $e');
      throw e;
    }
  }
  // #endregion
}
