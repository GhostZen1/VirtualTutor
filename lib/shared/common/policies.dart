import 'package:tosl_operation/modules/global.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  final String policyUrl = "https://www.tosloperation.com/privacy_policy.pdf";

  Future<void> _launchPolicyUrl(BuildContext context) async {
    final Uri url = Uri.parse(policyUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the Privacy Policy")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        //automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 16),
            Text(
              "Last Updated: May 22, 2025",
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Commitment",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "At this operation, your privacy is our priority. We implement industry-standard security measures, including encryption and access controls, to protect your personal information.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  "View Full Privacy Policy",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "Download or view our complete Privacy Policy for details on data collection, usage, and your rights.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing:
                    const Icon(Icons.picture_as_pdf, color: Colors.blueAccent),
                onTap: () => _launchPolicyUrl(context),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact Us",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "For questions or to exercise your data rights, contact our Privacy Officer at 011-11414680 (Iman)",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
