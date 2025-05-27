import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class AdminDashboardController {
  Future<Map<String, int>> fetchDashboardStats() async {
    final response =
        await http.get(Uri.parse("${ApiBase.baseUrl}getDashboardStats.php"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        "totalCourses": data["totalCourses"] ?? 0,
        "totalTeachers": data["totalTeachers"] ?? 0,
        "pendingApprovals": data["pendingApprovals"] ?? 0,
      };
    } else {
      throw Exception("Failed to load dashboard stats");
    }
  }

  Future<List<Map<String, String>>> fetchListCourseAvailable() async {
    final response = await http
        .get(Uri.parse("${ApiBase.baseUrl}getListCourseAvailable.php"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "success") {
        final List courseAvailable = data["data"];

        return courseAvailable.map<Map<String, String>>((courseAvailable) {
          return {
            "CourseID": courseAvailable["CourseID"]?.toString() ?? "",
            "Name": courseAvailable["Name"] ?? "",
            "Category": courseAvailable["Category"] ?? "",
            "Description": courseAvailable["Description"] ?? "",
          };
        }).toList();
      } else {
        throw Exception("Backend returned failure status");
      }
    } else {
      throw Exception("Failed to load course list");
    }
  }

  Future<List<Map<String, String>>> fetchListTeacher() async {
    final response =
        await http.get(Uri.parse("${ApiBase.baseUrl}getTeacherList.php"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "success") {
        final List teachers = data["data"];

        return teachers
            .where((t) => t["Role"].toString().toLowerCase() == "teacher")
            .map<Map<String, String>>((teacher) {
          return {
            "UserId": teacher["UserId"]?.toString() ?? "",
            "Username": teacher["Username"] ?? "",
            "Email": teacher["Email"] ?? "",
            "Qualification": teacher["Qualification"] ?? "",
          };
        }).toList();
      } else {
        throw Exception("Backend returned failure status");
      }
    } else {
      throw Exception("Failed to load teacher list");
    }
  }

  Future<bool> assignTeacherToCourse({
    required String userId,
    required String courseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}assignTeacherToCourse.php"),
        body: {
          'UserId': userId,
          'CourseID': courseId,
        },
      );

      if (response.statusCode == 200 && response.body.contains("success")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<(bool, String?)> checkAssignedCourse(String courseId) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}getAssignTeacher.php"),
        body: {'courseId': courseId},
      );

      print(
          'checkAssignedCourse Response for CourseID $courseId: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return (data['assigned'] == true, data['teacherId']?.toString());
        }
      }
      return (false, null);
    } catch (e) {
      print('checkAssignedCourse Error for CourseID $courseId: $e');
      return (false, null);
    }
  }

  Future<Map<String, String>?> addCourse({
    required String name,
    String? category,
    String? description,
    String? userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}addCourse.php"),
        body: {
          'Name': name,
          'Category': category ?? '',
          'Description': description ?? '',
          'UserId': userId ?? '',
        },
      );

      print('addCourse Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return {
            'CourseID': data['data']['CourseId']?.toString() ?? '',
            'Name': data['data']['Name'] ?? '',
            'Category': data['data']['Category'] ?? '',
            'Description': data['data']['Description'] ?? '',
            'UserId': data['data']['UserId']?.toString() ?? '',
          };
        }
      }
      return null;
    } catch (e) {
      print('addCourse Error: $e');
      return null;
    }
  }

  Future<List<Map<String, String>>> fetchPendingTeachers() async {
    try {
      final response = await http.get(
          Uri.parse("${ApiBase.baseUrl}approveTeacher.php?action=getPending"));

      print(
          'fetchPendingTeachers Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return List<Map<String, String>>.from(data['data'].map((teacher) => {
                'UserId': teacher['UserId'].toString(),
                'Username': teacher['Username']?.toString() ?? '',
                'Qualification': teacher['Qualification']?.toString() ?? '',
                'fileId': teacher['fileId'].toString(),
                'ResumeUrl': teacher['ResumeUrl']?.toString() ?? '',
              }));
        }
      }
      throw Exception("Failed to load pending teachers");
    } catch (e) {
      print('fetchPendingTeachers Error: $e');
      throw Exception("Error: $e");
    }
  }

  Future<bool> approveTeacher(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}approveTeacher.php?action=Approve"),
        body: {'UserId': userId},
      );

      print(
          'approveTeacher Response for UserId $userId: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('approveTeacher Error: $e');
      return false;
    }
  }

  Future<bool> rejectTeacher(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}approveTeacher.php?action=Reject"),
        body: {'UserId': userId},
      );

      print(
          'rejectTeacher Response for UserId $userId: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('rejectTeacher Error: $e');
      return false;
    }
  }
}
