import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/screen/courseList.dart';
import 'package:tosl_operation/modules/teacher/screen/subscreen/studentList.dart';
import 'package:tosl_operation/modules/teacher/screen/teacherHomepage.dart';
import 'package:tosl_operation/shared/common/profile.dart';

class TeacherRoutePage extends StatefulWidget {
  final int userId;
  const TeacherRoutePage({super.key, required this.userId});

  @override
  Route createState() => Route();
}

class Route extends State<TeacherRoutePage> {
  int _currentIndex = 0;

  // Track if we're in the sub-screen
  Widget? _innerScreen;

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
      _innerScreen = null;
    });
  }

  void _showInnerScreen(Widget screen) {
    setState(() {
      _innerScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TeacherHomeScreen(userId: widget.userId),
      CourseListScreen(onSelectCourse: (courseTitle) {
        _showInnerScreen(StudentListScreen(
          courseTitle: courseTitle,
          onBack: () {
            setState(() {
              _innerScreen = null;
            });
          },
        ));
      }),
      ProfileScreen(userId: widget.userId),
      //ProfileScreen(userId: widget.userId),
    ];

    return Scaffold(
      body: Stack(
        children: [
          screens[_currentIndex],
          if (_innerScreen != null) _innerScreen!,
        ],
      ),
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
          'Courses List',
          'My Profile',
        ],
      ),
    );
  }
}
