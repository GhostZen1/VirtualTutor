import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class ProfileModel {
  final int userId;
  final String username;
  final String email;
  final String? profilePicture; // Add this field

  ProfileModel({
    required this.userId,
    required this.username,
    required this.email,
    this.profilePicture, // Make it optional
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['UserId'] is String
          ? int.parse(json['UserId'])
          : json['UserId'] ?? 0,
      username: json['Username'] ?? '',
      email: json['Email'] ?? '',
      profilePicture: json['ProfilePicture'], // Add this
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'Username': username,
      'Email': email,
      'ProfilePicture': profilePicture, // Add this
    };
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

  static Future<Map<String, dynamic>> uploadProfilePicture({
    required int userId,
    required String imagePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiBase.baseUrl}uploadProfilePicture.php'),
      );

      // Add user ID
      request.fields['UserId'] = userId.toString();

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('profile_picture', imagePath),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        return data;
      } else {
        return {
          'status': 'error',
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
