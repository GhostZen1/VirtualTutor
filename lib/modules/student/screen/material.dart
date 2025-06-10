import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';

class MaterialScreen extends StatefulWidget {
  final int chapterId;
  final String chapterTitle;
  final String userId;

  const MaterialScreen(
      {super.key,
      required this.chapterId,
      required this.chapterTitle,
      required this.userId});

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

  // Toggle material completion status
  Future<void> toggleMaterialCompletion(int materialId, bool isDone) async {
    try {
      final success = await controller.updateMaterialStatus(
          materialId, isDone, widget.userId);
      if (success) {
        setState(() {
          final materialIndex =
              materials.indexWhere((m) => m['id'] == materialId);
          if (materialIndex != -1) {
            materials[materialIndex]['isDone'] = isDone ? 1 : 0;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDone
                ? 'Material marked as completed!'
                : 'Material marked as incomplete'),
            backgroundColor: isDone ? Colors.green : Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update material status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating material status: $e'),
          backgroundColor: Colors.red,
        ),
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
                                materialId: material['id'] ?? 0,
                                title: material['title'] ?? 'Untitled Material',
                                type: material['type'] ?? 'Unknown',
                                url: material['url'] ?? '',
                                isDone: (material['isDone'] ?? 0) == 1,
                                onToggleCompletion: toggleMaterialCompletion,
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
  final int materialId;
  final String title;
  final String type;
  final String url;
  final bool isDone;
  final Function(int, bool) onToggleCompletion;

  const MaterialCard({
    super.key,
    required this.materialId,
    required this.title,
    required this.type,
    required this.url,
    required this.isDone,
    required this.onToggleCompletion,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? Colors.grey[600] : null,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isDone,
                    onChanged: (bool? value) {
                      onToggleCompletion(materialId, value ?? false);
                    },
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Type: $type",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (isDone) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Completed",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
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
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onToggleCompletion(materialId, !isDone);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDone ? Colors.orange : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(isDone ? 'Mark Incomplete' : 'Mark Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
