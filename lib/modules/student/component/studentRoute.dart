import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/screen/course.dart';
import 'package:tosl_operation/modules/student/screen/homepage.dart';
import 'package:tosl_operation/shared/common/profile.dart' show ProfileScreen;

class StudentRoutePage extends StatefulWidget {
  final int userId;
  const StudentRoutePage({super.key, required this.userId});

  @override
  _Route createState() => _Route();
}

class _Route extends State<StudentRoutePage> {
  int _currentIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      CourseHomeScreen(userId: widget.userId),
      MyCoursesScreen(userId: widget.userId),
      ProfileScreen(userId: widget.userId),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        icons: const [
          Icons.home,
          Icons.play_circle,
          Icons.person,
        ],
        labels: const [
          'Home',
          'My Courses',
          'My Profile',
        ],
      ),
    );
  }
}
