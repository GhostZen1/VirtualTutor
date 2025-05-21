import 'package:tosl_operation/modules/auth/component/UserSession.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Future<void> loginValidation(
    BuildContext context,
    String username,
    String password,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and password are required')),
      );
      return;
    }

    final url = Uri.parse("${ApiBase.baseUrl}login.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"username": username, "password": password}),
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          int userId = responseBody['UserId'];
          String userType = responseBody['Role'];

          UserSession().setUser(userId, userType);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );

          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          await Future.delayed(const Duration(milliseconds: 500));

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainRouteManager(
                      userId: userId,
                      userType: userType,
                    )),
          ).then((_) {
            Navigator.of(context).pop();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['message'] ?? 'Login failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server error.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
