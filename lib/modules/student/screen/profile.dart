import 'package:tosl_operation/modules/auth/screen/login.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/controlller/getUserDetail.dart';
import 'package:tosl_operation/modules/student/studentModel.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int userId;
  UserModel? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    loadUserData();

    print("User ID: $userId");
  }

  Future<void> loadUserData() async {
    final fetchedUser = await StudentServices.fetchUserById(widget.userId);

    if (fetchedUser != null) {
      setState(() {
        userData = fetchedUser as UserModel?;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Personal Info Card
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple,
                        child:
                            Icon(Icons.person, size: 30, color: Colors.white)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userData?.username ?? 'Default',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(userData?.email ?? 'default@mail.com',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle edit profile
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Options
        const Text("Settings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text("Change Password"),
          onTap: () {
            // Handle password change
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout", style: TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
