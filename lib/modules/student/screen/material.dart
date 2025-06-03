import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';

class MaterialScreen extends StatefulWidget {
  final int chapterId;
  final String chapterTitle;

  const MaterialScreen({
    super.key,
    required this.chapterId,
    required this.chapterTitle,
  });

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final CourseController controller = CourseController();
  List<Map<String, dynamic>> materials = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMaterials();
  }

  // Load materials for the chapter
  Future<void> loadMaterials() async {
    try {
      final fetchedMaterials =
          await controller.fetchChapterMaterials(widget.chapterId);
      setState(() {
        materials = fetchedMaterials;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading materials: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Materials',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : materials.isEmpty
                        ? const Center(child: Text('No materials available'))
                        : ListView.separated(
                            itemCount: materials.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final material = materials[index];
                              return MaterialCard(
                                title: material['title'] ?? 'Untitled Material',
                                type: material['type'] ?? 'Unknown',
                                url: material['url'] ?? '',
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MaterialCard extends StatelessWidget {
  final String title;
  final String type;
  final String url;

  const MaterialCard({
    super.key,
    required this.title,
    required this.type,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Type: $type",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: url.isNotEmpty
                  ? () async {
                      await openMaterial(type, url, context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Material'),
            ),
          ],
        ),
      ),
    );
  }
}
