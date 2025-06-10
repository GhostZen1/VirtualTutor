import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/global.dart';

class TeacherController {
  static Future<UserModel> fetchTeacherById(String userId) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}getTeacherById.php'),
      body: {'userId': userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        print(data);
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }
}

class UserModel {
  final String userId;
  final String username;
  final String name;
  final String courseId;

  UserModel({
    required this.userId,
    required this.username,
    required this.name,
    required this.courseId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['UserId'],
      username: json['Username'],
      name: json['Name'],
      courseId: json['CourseID'],
    );
  }
}
