import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/controller/chapterController.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ManageChapterMaterialsScreen extends StatefulWidget {
  final int chapterId;
  final String chapterTitle;

  const ManageChapterMaterialsScreen({
    super.key,
    required this.chapterId,
    required this.chapterTitle,
  });

  @override
  State<ManageChapterMaterialsScreen> createState() =>
      _ManageChapterMaterialsScreenState();
}

class _ManageChapterMaterialsScreenState
    extends State<ManageChapterMaterialsScreen> {
  final ChapterController controller = ChapterController();
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

  // Show add material dialog
  void showAddMaterialDialog() {
    showDialog(
      context: context,
      builder: (context) => AddMaterialDialog(
        chapterId: widget.chapterId,
        onMaterialAdded: loadMaterials,
      ),
    );
  }

  // Delete material
  Future<void> deleteMaterial(int materialId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Material'),
        content: const Text(
            'Are you sure you want to delete this material? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await controller.deleteMaterial(materialId);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Material deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          loadMaterials(); // Refresh the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete material'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting material: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Toggle material availability
  Future<void> toggleMaterialAvailability(
      int materialId, bool isAvailable) async {
    try {
      final success =
          await controller.updateMaterialAvailability(materialId, isAvailable);
      if (success) {
        setState(() {
          final materialIndex =
              materials.indexWhere((m) => m['id'] == materialId);
          if (materialIndex != -1) {
            materials[materialIndex]['is_available'] = isAvailable ? 1 : 0;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAvailable
                ? 'Material marked as available!'
                : 'Material marked as unavailable'),
            backgroundColor: isAvailable ? Colors.green : Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update material availability'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating material availability: $e'),
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
              const Text(
                'Materials',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              return MaterialManagementCard(
                                materialId: material['id'] ?? 0,
                                title: material['title'] ?? 'Untitled Material',
                                type: material['type'] ?? 'Unknown',
                                url: material['url'] ?? '',
                                description: material['description'] ?? '',
                                materialOrder: material['material_order'] ?? 0,
                                isDownloadable:
                                    (material['is_downloadable'] ?? 0) == 1,
                                isAvailable:
                                    (material['is_available'] ?? 1) == 1,
                                fileSize: material['file_size'] ?? '',
                                onDelete: () =>
                                    deleteMaterial(material['id'] ?? 0),
                                onToggleAvailability:
                                    toggleMaterialAvailability,
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddMaterialDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class MaterialManagementCard extends StatelessWidget {
  final int materialId;
  final String title;
  final String type;
  final String url;
  final String description;
  final int materialOrder;
  final bool isDownloadable;
  final bool isAvailable;
  final String fileSize;
  final VoidCallback onDelete;
  final Function(int, bool) onToggleAvailability;

  const MaterialManagementCard({
    super.key,
    required this.materialId,
    required this.title,
    required this.type,
    required this.url,
    required this.description,
    required this.materialOrder,
    required this.isDownloadable,
    required this.isAvailable,
    required this.fileSize,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  IconData getTypeIcon() {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.play_circle;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'document':
        return Icons.description;
      case 'link':
        return Icons.link;
      default:
        return Icons.insert_drive_file;
    }
  }

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
                Icon(
                  getTypeIcon(),
                  size: 24,
                  color: isAvailable ? Colors.deepPurple : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material $materialOrder',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isAvailable ? null : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Material',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Type: $type",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (fileSize.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Text(
                    "Size: $fileSize",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
                if (isDownloadable) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.download,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  Text(
                    " Downloadable",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isAvailable ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  isAvailable ? "Available" : "Unavailable",
                  style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
                    child: const Text('Preview Material'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onToggleAvailability(materialId, !isAvailable);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable ? Colors.orange : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child:
                      Text(isAvailable ? 'Mark Unavailable' : 'Mark Available'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddMaterialDialog extends StatefulWidget {
  final int chapterId;
  final VoidCallback onMaterialAdded;

  const AddMaterialDialog({
    super.key,
    required this.chapterId,
    required this.onMaterialAdded,
  });

  @override
  State<AddMaterialDialog> createState() => _AddMaterialDialogState();
}

class _AddMaterialDialogState extends State<AddMaterialDialog> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderController = TextEditingController();
  final _fileSizeController = TextEditingController();
  final ChapterController controller = ChapterController();

  String selectedType = 'video';
  bool isDownloadable = false;
  bool isLoading = false;

  final List<String> materialTypes = [
    'video',
    'pdf',
    'document',
    'link',
    'image',
    'audio'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    _fileSizeController.dispose();
    super.dispose();
  }

  Future<void> addMaterial() async {
    if (_titleController.text.trim().isEmpty ||
        _urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and URL')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await controller.addMaterial(
        chapterId: widget.chapterId,
        title: _titleController.text.trim(),
        type: selectedType,
        url: _urlController.text.trim(),
        description: _descriptionController.text.trim(),
        fileSize: _fileSizeController.text.trim(),
        // materialOrder: int.tryParse(_orderController.text) ?? 1,
        isDownloadable: isDownloadable,
      );

      if (success) {
        Navigator.pop(context);
        widget.onMaterialAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Material added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add material'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding material: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Material'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Material Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Material Type',
                border: OutlineInputBorder(),
              ),
              items: materialTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                FileType fileType = FileType.custom;

                List<String> allowedExtensions = [];
                if (selectedType == 'pdf') {
                  allowedExtensions = ['pdf'];
                } else if (selectedType == 'video') {
                  allowedExtensions = ['mp4', 'avi', 'mov'];
                } else if (selectedType == 'image') {
                  allowedExtensions = ['jpg', 'jpeg', 'png'];
                } else if (selectedType == 'audio') {
                  allowedExtensions = ['mp3', 'wav'];
                } else if (selectedType == 'document') {
                  allowedExtensions = ['doc', 'docx', 'ppt', 'pptx'];
                } else if (selectedType == 'link') {
                  // Skip file picker, show input dialog
                  final link = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final linkController = TextEditingController();
                      return AlertDialog(
                        title: const Text('Enter URL'),
                        content: TextField(
                          controller: linkController,
                          decoration: const InputDecoration(
                              labelText: 'Paste the link'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(
                                  context, linkController.text.trim()),
                              child: const Text('OK')),
                        ],
                      );
                    },
                  );
                  if (link != null && link.isNotEmpty) {
                    setState(() {
                      _urlController.text = link;
                      _fileSizeController.text = "Link";
                    });
                  }
                  return;
                }

                final result = await FilePicker.platform.pickFiles(
                  type: fileType,
                  allowedExtensions: allowedExtensions,
                );

                if (result != null && result.files.isNotEmpty) {
                  final file = result.files.first;
                  final fileName = path.basename(file.name);
                  final fileSizeInKB = (file.size / 1024).toStringAsFixed(2);
                  final uploadUrl =
                      Uri.parse('${ApiBase.baseUrl}uploadFile.php');

                  var request = http.MultipartRequest('POST', uploadUrl);
                  request.files.add(
                      await http.MultipartFile.fromPath('file', file.path!));

                  var response = await request.send();

                  if (response.statusCode == 200) {
                    setState(() {
                      _urlController.text =
                          '${ApiBase.baseUrl}uploads/$fileName';
                      _fileSizeController.text = fileSizeInKB;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('File uploaded successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Upload failed'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
              },
              label: const Text('Upload Material'),
            ),

            // const SizedBox(height: 16),
            // TextField(
            //   controller: _orderController,
            //   decoration: const InputDecoration(
            //     labelText: 'Material Order',
            //     border: OutlineInputBorder(),
            //   ),
            //   keyboardType: TextInputType.number,
            // ),
            const SizedBox(height: 16),
            TextField(
              controller: _fileSizeController,
              decoration: const InputDecoration(
                labelText: 'File Size (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _urlController.text.isNotEmpty &&
                selectedType != null) {
              addMaterial();
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all required fields'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Add Material'),
        ),
      ],
    );
  }
}
