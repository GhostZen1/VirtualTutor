import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/global.dart';

class FeedbackService {
  static Future<List<Map<String, dynamic>>> getTeacherReviews(
      int teacherId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiBase.baseUrl}feedback.php?action=teacher_reviews&teacher_id=$teacherId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Failed to load reviews: ${data['error']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get reviews by a specific student
  static Future<List<Map<String, dynamic>>> getStudentReviews(
      int studentId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiBase.baseUrl}feedback.php?action=student_reviews&student_id=$studentId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Failed to load reviews: ${data['error']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get reviews for a specific course
  static Future<Map<String, dynamic>> getCourseReviews(int courseId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiBase.baseUrl}feedback.php?action=course_reviews&course_id=$courseId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return {
            'reviews': List<Map<String, dynamic>>.from(data['data']),
            'averageRating': data['averageRating'],
            'count': data['count']
          };
        } else {
          throw Exception('Failed to load reviews: ${data['error']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Submit new feedback
  static Future<bool> submitFeedback({
    required int studentId,
    required int teacherId,
    int? courseId,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}feedback.php'),
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
        return data['success'] ?? false;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update existing feedback
  static Future<bool> updateFeedback({
    required int feedbackId,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiBase.baseUrl}feedback.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'feedbackId': feedbackId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete feedback
  static Future<bool> deleteFeedback(int feedbackId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiBase.baseUrl}feedback.php?feedback_id=$feedbackId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
