import 'package:tosl_operation/modules/auth/screen/login.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/shared/common/policies.dart';
import 'package:tosl_operation/shared/utils/getProfileData.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late int userId;
  ProfileModel? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    loadUserData();
  }

  Future<void> loadUserData() async {
    final fetchedUser = await ProfileServices.fetchUserById(widget.userId);

    if (fetchedUser != null) {
      setState(() {
        userData = fetchedUser as ProfileModel?;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Text(
              '${userData?.username ?? 'Default'} Account',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 8),
            Text(
              "Manage your account settings and preferences.",
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 24),

            // Profile Details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(userData?.username ?? 'Default',
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text(userData?.email ?? 'default@mail.com',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
            const SizedBox(height: 16),

            // Change Password
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Change Password",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'current_password',
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'new_password',
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        //TODO: Confirmation Password
                        name: 'confirm_password',
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value !=
                              _formKey.currentState?.fields['new_password']
                                  ?.value) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            // Simulate password change (replace with backend call)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Password updated successfully")),
                            );
                          }
                        },
                        child: const Text("Update Password"),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
            const SizedBox(height: 16),

            // Policies
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text("View Policies",
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text(
                  "Review our privacy policy and terms of service.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PoliciesScreen()),
                  );
                },
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 800.ms),
            const SizedBox(height: 16),

            // Logout
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  "Logout",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                ),
                trailing: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
