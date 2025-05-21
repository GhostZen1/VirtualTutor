import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/student/studentModel.dart';

class StudentServices {
  static Future<UserModel?> fetchUserById(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}fetchStudentData.php'),
      body: jsonEncode({'UserId': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return UserModel.fromJson(data['user']);
      }
    }
    return null;
  }
}
