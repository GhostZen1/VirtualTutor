import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class RegisterController {
  Future<void> registerValidation({
    required BuildContext context,
    required String username,
    required String ic,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
    String? qualification,
    File? document,
  }) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      http.Response response;

      if (role == 'Teacher') {
        var uri = Uri.parse("${ApiBase.baseUrl}TeacherReg.php");
        var request = http.MultipartRequest("POST", uri);
        request.fields['full_name'] = username;
        request.fields['email'] = email;
        request.fields['password'] = password;
        request.fields['qualification'] = qualification ?? '';

        if (document != null) {
          request.files.add(
              await http.MultipartFile.fromPath('pdf_file', document.path));
        }

        var streamedResponse = await request.send();
        var responseBody = await streamedResponse.stream.bytesToString();
        response = http.Response(responseBody, streamedResponse.statusCode);
      } else {
        var uri = Uri.parse("${ApiBase.baseUrl}registerStudent.php");
        var jsonBody = json.encode({
          'full_name': username,
          'ic_number': ic,
          'email': email,
          'password': password,
          'user_type': role,
        });

        response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonBody,
        );
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registration successful')),
        );
        Navigator.pop(context); // Navigate back or to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
