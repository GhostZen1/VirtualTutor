import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/auth/screen/login.dart';
import 'package:tosl_operation/shared/common/policies.dart';
import 'package:tosl_operation/shared/utils/getProfileData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isUploadingImage = false;
  final ImagePicker _picker = ImagePicker();

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
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data')),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to access storage')),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          isUploadingImage = true;
        });

        final result = await ProfileServices.uploadProfilePicture(
          userId: widget.userId,
          imagePath: image.path,
        );

        if (result['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result['message'] ?? 'Profile picture updated!')),
          );
          await loadUserData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    result['message'] ?? 'Failed to update profile picture')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() {
        isUploadingImage = false;
      });
    }
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueAccent,
          backgroundImage: userData?.profilePicture != null &&
                  userData!.profilePicture!.isNotEmpty
              ? NetworkImage(
                  '${ApiBase.baseUrl}uploads/profiles/${userData!.profilePicture}')
              : null,
          child: userData?.profilePicture == null ||
                  userData!.profilePicture!.isEmpty
              ? const Icon(Icons.person, color: Colors.white, size: 50)
              : null,
        ),
        if (isUploadingImage)
          const Positioned.fill(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black54,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: isUploadingImage ? null : _pickAndUploadImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildProfileImage(),
                              const SizedBox(height: 16),
                              Text(userData!.username,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              Text(userData!.email,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
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
