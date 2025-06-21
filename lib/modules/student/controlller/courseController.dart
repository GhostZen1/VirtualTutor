import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/student/studentModel.dart';

class CourseController {
  Future<Map<String, dynamic>> _fetchUser(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}fetchStudentData.php'),
      body: jsonEncode({'UserId': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data;
      }
    }
    throw Exception('Failed to fetch user data');
  }

  Future<Map<String, dynamic>> loadUserAndCourses(int userId) async {
    try {
      final data = await _fetchUser(userId);
      final userJson = data['user'];
      final coursesJson = data['courses'] as List;

      print("User JSON: $userJson");
      final user = UserModel.fromJson(userJson);
      print("User details: $user");

      final courses =
          coursesJson.map((course) => course as Map<String, dynamic>).toList();

      return {
        'user': user,
        'courses': courses,
      };
    } catch (e) {
      throw Exception('Error loading user and courses: $e');
    }
  }

  Future enrollInCourse(int userId, int courseId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}enrollCourse.php'),
        body: jsonEncode({'userId': userId, 'courseId': courseId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error enrolling in course: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCourseChapters(
      String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}getCourseChapters.php?courseId=$courseId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("response $data");
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['chapters']);
        }
      }
      throw Exception('Failed to fetch chapters');
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchChapterMaterials(
      int chapterId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiBase.baseUrl}getChapterMaterials.php?chapterId=$chapterId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['materials']);
        }
      }
      throw Exception('Failed to fetch materials');
    } catch (e) {
      throw Exception('Error fetching materials: $e');
    }
  }

  Future<bool> updateMaterialStatus(
      int materialId, bool isDone, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}updateMaterialStatus.php'),
        body: jsonEncode({
          'materialId': materialId,
          'isDone': isDone ? 1 : 0,
          'userId': userId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error updating material status: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchEnrollCourse(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}fetchEnrollCourse.php?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final enrollments = List<Map<String, dynamic>>.from(data['data']);

        if (enrollments.isEmpty) {
          // Return empty user and courses
          return {
            'user': null,
            'courses': [],
          };
        }
        final first = enrollments.first;
        final user = {
          'EnrollmentId': first['EnrollmentId'],
          'CourseId': first['CourseId'],
          'CompletionStatus': first['CompletionStatus'],
          'Progress': first['Progress'],
          'teachername': first['teachername'],
          'Name': first['Name'],
          'Category': first['Category'],
          'Description': first['Description'],
          // add other user fields if needed
        };

        // Prepare courses list from enrollment data (map to course objects)
        // Note: You need to add course details here if your API returns them,
        // or you may need to make another API call to get course info by CourseId.
        final courses = enrollments.map((e) {
          return {
            'title': '${e['Name']}',
            'teacher': '${e['teachername']}',
            'icon': 'school',
            'progress': (e['Progress'] as num?)?.toDouble() ?? 0.0,
            'courseId': '${e['CourseId']}',
          };
        }).toList();

        return {
          'user': user,
          'courses': courses,
        };
      } else {
        throw Exception('Server returned failure status');
      }
    } else {
      throw Exception('Failed to fetch user enroll data');
    }
  }

  // Future<List<Map<String, dynamic>>> fetchCourseChapters(
  //     String courseId) async {
  //   final response = await http.post(
  //     Uri.parse('${ApiBase.baseUrl}fetchChapters.php'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'course_id': courseId}),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     if (data['success'] == true) {
  //       return List<Map<String, dynamic>>.from(data['chapters']);
  //     }
  //   }
  //   throw Exception('Failed to fetch chapters');
  // }

  Future<List<Map<String, dynamic>>> fetchCourseQuizzes(String courseId) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}fetchQuizzes.php?course_id=${courseId}'),
      // headers: {'Content-Type': 'application/json'},
      // body: json.encode({'course_id': courseId}),
    );
    print('courseid ${courseId}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['quizzes']);
      }
    }
    throw Exception('Failed to fetch quizzes asdsadas');
  }

  Future<Map<String, dynamic>> submitQuiz({
    required String userId,
    required String quizId,
    required Map<String, String> answers,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}submitQuiz.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'quizId': quizId,
        'answers': answers,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return {
          'totalMarks': data['totalMarks'],
          'percentage': data['percentage'],
          'totalQuestions': data['totalQuestions'],
        };
      }
    }
    throw Exception('Failed to submit quiz: ${response.body}');
  }

  Future<int> getTeacherId({required String courseId}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}getTeacherId.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'courseId': courseId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return data['teacherId'] as int;
        } else {
          throw Exception('Failed to get teacher ID: ${data['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching teacher ID: $e');
    }
  }

  Future<bool> submitFeedback({
    required String studentId,
    required String teacherId,
    required String courseId,
    required int rating,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}submitFeedback.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'studentId': studentId,
        'teacherId': teacherId,
        'courseId': courseId,
        'rating': rating,
        'comment': comment,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    }
    throw Exception('Failed to submit feedback: ${response.body}');
  }

  Future<bool> finishCourse({
    required String userId,
    required String courseId,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}finishCourse.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'courseId': courseId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  Future<String?> fetchEnrollmentStatus({
    required String userId,
    required String courseId,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}getEnrollmentStatus.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'courseId': courseId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return data['status'];
      }
    }
    throw Exception('Failed to fetch enrollment status');
  }
}
