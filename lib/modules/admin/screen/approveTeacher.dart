import 'package:tosl_operation/modules/global.dart';

class ApproveTeacherScreen extends StatelessWidget {
  final List<Map<String, String>> pendingTeachers = [
    {
      "name": "John Doe",
      "subject": "Math",
      "qualification": "Master's Degree",
      "resume": "https://example.com/john_resume.pdf"
    },
    {
      "name": "Jane Smith",
      "subject": "English",
      "qualification": "Bachelor's Degree",
      "resume": "https://example.com/jane_resume.pdf"
    },
  ];

  ApproveTeacherScreen({super.key});

  void _showApprovalModal(BuildContext context, Map<String, String> teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Review ${teacher['name']}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Subject: ${teacher['subject']}",
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                Text("Qualification: ${teacher['qualification']}",
                    style: Theme.of(context).textTheme.bodyMedium),
                //const SizedBox(height: 20),
                // ElevatedButton.icon(
                //   icon: const Icon(Icons.visibility),
                //   label: const Text("View Profile"),
                //   onPressed: () {
                //     // Simulate profile view (replace with actual logic)
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //           content:
                //               Text("Viewing ${teacher['name']}'s profile")),
                //     );
                //   },
                // ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download Resume"),
                  onPressed: () async {
                    final url = teacher['resume']!;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cannot open resume")),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // Approve logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${teacher['name']} approved")),
                );
              },
              child: const Text("Approve"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Reject logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${teacher['name']} rejected")),
                );
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
      appBar: AppBar(title: const Text("Approve Teachers")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pendingTeachers.length,
        itemBuilder: (context, index) {
          final teacher = pendingTeachers[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(teacher["name"] ?? "",
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text(
                  "Subject: ${teacher["subject"]}\nQualification: ${teacher["qualification"]}",
                  style: Theme.of(context).textTheme.bodyMedium),
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
