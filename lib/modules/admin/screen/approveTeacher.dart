import 'package:tosl_operation/modules/admin/component/lauchurl.dart';
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/admin/controller/adminController.dart';

class ApproveTeacherScreen extends StatefulWidget {
  const ApproveTeacherScreen({super.key});

  @override
  ApproveTeacherScreenState createState() => ApproveTeacherScreenState();
}

class ApproveTeacherScreenState extends State<ApproveTeacherScreen> {
  List<Map<String, String>> pendingTeachers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingTeachers();
  }

  Future<void> _loadPendingTeachers() async {
    try {
      final teachers = await AdminDashboardController().fetchPendingTeachers();
      print('Loaded teachers: $teachers');
      setState(() {
        pendingTeachers = teachers;
        isLoading = false;
      });
    } catch (e) {
      print('Error in _loadPendingTeachers: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading teachers: $e")),
      );
    }
  }

  void _showApprovalModal(BuildContext context, Map<String, String> teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Review ${teacher['Username']}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Qualification: ${teacher['Qualification']}",
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download Resume"),
                  onPressed: () async {
                    final url = teacher['ResumeUrl'] ?? '';
                    if (url.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No resume available")),
                      );
                      return;
                    }

                    final fileName = url.split('/').last;
                    await downloadAndOpenFile(url, fileName);

                    // final uri = Uri.parse(url);
                    // try {
                    //   if (await canLaunchUrl(uri)) {
                    //     await launchUrl(uri,
                    //         mode: LaunchMode.externalApplication);
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text("Opening resume...")),
                    //     );
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text("Cannot open URL: $url")),
                    //     );
                    //   }
                    // } catch (e) {
                    //   print('Error opening URL: $e');
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text("Error opening resume: $e")),
                    //   );
                    // }
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                final success = await AdminDashboardController()
                    .approveTeacher(teacher['UserId'] ?? '');
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${teacher['Username']} approved")),
                  );
                  _loadPendingTeachers();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to approve teacher")),
                  );
                }
              },
              child: const Text("Approve"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final success = await AdminDashboardController()
                    .rejectTeacher(teacher['UserId'] ?? '');
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${teacher['Username']} rejected")),
                  );
                  _loadPendingTeachers();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to reject teacher")),
                  );
                }
              },
              child: const Text("Reject"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scale();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approve Teachers"),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingTeachers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        "No pending teachers",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingTeachers.length,
                  itemBuilder: (context, index) {
                    final teacher = pendingTeachers[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          teacher["Username"] ?? "",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          "Qualification: ${teacher["Qualification"]}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showApprovalModal(context, teacher),
                        ),
                        onTap: () => _showApprovalModal(context, teacher),
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideX();
                  },
                ),
    );
  }
}
