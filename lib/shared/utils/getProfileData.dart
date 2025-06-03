import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class ProfileModel {
  final int userId;
  final String username;
  final String email;

  ProfileModel({
    required this.userId,
    required this.username,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['UserId'] is String
          ? int.parse(json['UserId'])
          : json['UserId'] ?? 0,
      username: json['Username'] ?? '',
      email: json['Email'] ?? '',
    );
  }
}

class ProfileServices {
  static Future<ProfileModel?> fetchUserById(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}getProfileList.php'),
        body: jsonEncode({'UserId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final userList = data['user'];
          if (userList.isNotEmpty) {
            return ProfileModel.fromJson(userList[0]);
          }
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}changePassword.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UserId': userId,
          'CurrentPassword': currentPassword,
          'NewPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
