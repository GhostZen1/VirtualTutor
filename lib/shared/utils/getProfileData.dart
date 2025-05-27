import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class ProfileModel {
  final int userId;
  final String username;
  final String email;
  final String role;
  final String? createDate;

  ProfileModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    this.createDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['UserId'],
      username: json['Username'],
      email: json['Email'],
      role: json['Role'],
      createDate: json['CreateDate'],
    );
  }
}

class ProfileServices {
  static Future<ProfileModel?> fetchUserById(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}fetchStudentData.php'),
      body: jsonEncode({'UserId': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return ProfileModel.fromJson(data['user']);
      }
    }
    return null;
  }
}
