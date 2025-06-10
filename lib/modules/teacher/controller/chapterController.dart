import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/global.dart';

class ChapterController {
  // Fetch chapters for a course
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

  // Add a new chapter
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

  // Delete a chapter
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

  // Fetch materials for a chapter
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

  // Add a new material
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

  // Delete a material
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

  // Update material availability
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
}
