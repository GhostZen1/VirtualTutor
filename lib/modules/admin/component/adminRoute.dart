import 'package:tosl_operation/modules/admin/screen/approveTeacher.dart';
import 'package:tosl_operation/modules/admin/screen/dashboard.dart';
import 'package:tosl_operation/modules/admin/screen/manageCourse.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/shared/common/profile.dart';

class AdminRoutePage extends StatefulWidget {
  final int userId;
  const AdminRoutePage({super.key, required this.userId});

  @override
  Route createState() => Route();
}

class Route extends State<AdminRoutePage> {
  int _currentIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DashboardScreen(),
      const ManageCourseScreen(),
      ApproveTeacherScreen(),
      ProfileScreen(
        userId: widget.userId,
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Admin Portal"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.person),
      //       tooltip: 'Profile',
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => const AdminProfileScreen()),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Theme.of(context).primaryColor,
      //         ),
      //         child: const Text(
      //           'Admin Menu',
      //           style: TextStyle(color: Colors.white, fontSize: 24),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.dashboard),
      //         title: const Text('Dashboard'),
      //         onTap: () {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const DashboardScreen()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.pending_actions),
      //         title: const Text('Approve Teachers'),
      //         onTap: () {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => ApproveTeacherScreen()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.book),
      //         title: const Text('Manage Courses'),
      //         onTap: () {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const ManageCourseScreen()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.person),
      //         title: const Text('Profile'),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const AdminProfileScreen()),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: screens[_currentIndex].animate().fadeIn(duration: 300.ms),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        icons: const [
          Icons.dashboard,
          Icons.book,
          Icons.pending_actions,
          Icons.person,
        ],
        labels: const [
          'Dashboard',
          'Manage Course',
          'Approve Teacher',
          'Profile',
        ],
      ),
    );
  }
}
