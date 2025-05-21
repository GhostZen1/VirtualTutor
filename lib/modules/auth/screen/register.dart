import 'package:tosl_operation/modules/auth/controller/registerController.dart';
import 'package:tosl_operation/modules/global.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedRole = 'Student';
  String selectedSubject = 'Diploma';
  String? uploadedFileName;
  File? uploadedFile;

  void RegisterHandle() {
    final username = nameController.text;
    final ic = icController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmpassword = confirmPasswordController.text;

    if (username.isEmpty ||
        ic.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    } else {
      RegisterController().registerValidation(
        context: context,
        username: username,
        ic: ic,
        email: email,
        password: password,
        confirmPassword: confirmpassword,
        role: selectedRole,
        qualification: selectedRole == 'Teacher' ? selectedSubject : null,
        document: uploadedFile,
      );
    }
  }

  void handleFileUpload() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        uploadedFileName = result.files.first.name;
        uploadedFile = File(result.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2)),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRoleButton('Student'),
                      const SizedBox(width: 8),
                      _buildRoleButton('Teacher'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Create An Account",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Please fulfill the requirement",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 24),

                  _buildTextField(
                      hint: "Full Name", controller: nameController),
                  const SizedBox(height: 16),
                  _buildTextField(hint: "IC Number", controller: icController),
                  const SizedBox(height: 16),
                  _buildTextField(hint: "Email", controller: emailController),

                  if (selectedRole == 'Teacher') ...[
                    const SizedBox(height: 16),
                    _buildDropdown(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: handleFileUpload,
                      icon: const Icon(Icons.upload_file),
                      label: Text(uploadedFileName ?? "Upload Document"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  _buildTextField(
                      hint: "Password",
                      controller: passwordController,
                      isObscure: true),
                  const SizedBox(height: 16),
                  _buildTextField(
                      hint: "Confirm Password",
                      controller: confirmPasswordController,
                      isObscure: true),
                  const SizedBox(height: 30),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: RegisterHandle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("REGISTER",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Log In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have An Account Already? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("Log In",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hint,
      required TextEditingController controller,
      bool isObscure = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    final bool isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurpleAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            role,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedSubject,
      items: ['Diploma', 'Degree', 'Master', 'PHD']
          .map((subject) =>
              DropdownMenuItem(value: subject, child: Text(subject)))
          .toList(),
      onChanged: (value) {
        setState(() => selectedSubject = value!);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Select Qualification",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}
