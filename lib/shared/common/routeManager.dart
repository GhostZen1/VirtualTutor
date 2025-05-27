import 'package:tosl_operation/modules/admin/component/adminRoute.dart';
import 'package:tosl_operation/modules/auth/screen/login.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/component/studentRoute.dart';
import 'package:tosl_operation/modules/teacher/component/teacherRoute.dart';

class MainRouteManager extends StatelessWidget {
  final int userId;
  final String userType;

  const MainRouteManager(
      {super.key, required this.userId, required this.userType});

  @override
  Widget build(BuildContext context) {
    switch (userType) {
      case 'Student':
        return StudentRoutePage(userId: userId);
      case 'Teacher':
        return TeacherRoutePage(userId: userId);
      case 'Admin':
        return AdminRoutePage(userId: userId);
      case 'Rejected':
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Rejected'),
              content: const Text('Your Request is Rejected by the Admin.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
        return const LoginScreen();
      case 'Pending':
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pending'),
              content: const Text(
                  'Please wait until your request is being approve by admin.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
        return const LoginScreen();
      default:
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Unknown user role.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
        return const LoginScreen();
    }
  }
}
