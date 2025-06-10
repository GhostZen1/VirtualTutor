import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/auth/screen/login.dart';
import 'package:tosl_operation/shared/common/policies.dart';
import 'package:tosl_operation/shared/utils/getProfileData.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  ProfileModel? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final fetchedUser = await ProfileServices.fetchUserById(widget.userId);
    if (fetchedUser != null) {
      setState(() {
        userData = fetchedUser;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // stop the loading indicator even if failed
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('No data available.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userData!.username} Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Manage your account settings and preferences.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(userData!.username,
                              style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text(userData!.email,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Change Password",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 16),
                                FormBuilderTextField(
                                  name: 'current_password',
                                  decoration: InputDecoration(
                                    labelText: 'Current Password',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  obscureText: true,
                                  validator: FormBuilderValidators.required(
                                      errorText:
                                          'Please enter your current password'),
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
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(6,
                                        errorText:
                                            'Password must be at least 6 characters'),
                                  ]),
                                ),
                                const SizedBox(height: 12),
                                FormBuilderTextField(
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
                                        _formKey.currentState
                                            ?.fields['new_password']?.value) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!
                                        .saveAndValidate()) {
                                      final currentPassword = _formKey
                                          .currentState!
                                          .fields['current_password']
                                          ?.value;
                                      final newPassword = _formKey.currentState!
                                          .fields['new_password']?.value;

                                      final result =
                                          await ProfileServices.changePassword(
                                        userId: widget.userId,
                                        currentPassword: currentPassword,
                                        newPassword: newPassword,
                                      );

                                      if (result['status'] == 'success') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(result['message'] ??
                                                  'Password updated!')),
                                        );
                                        _formKey.currentState?.reset();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(result['message'] ??
                                                  'Failed to update password')),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text("Update Password"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text("Logout",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.red)),
                          trailing: const Icon(Icons.logout, color: Colors.red),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
