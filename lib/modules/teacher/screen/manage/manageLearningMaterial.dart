import 'package:tosl_operation/modules/global.dart';

class ManageLearningMaterialScreen extends StatefulWidget {
  const ManageLearningMaterialScreen({super.key});

  @override
  ManageLearningMaterialScreenState createState() =>
      ManageLearningMaterialScreenState();
}

class ManageLearningMaterialScreenState
    extends State<ManageLearningMaterialScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<Map<String, String>> materials = [
    {"title": "Chapter 1: Introduction", "type": "PDF", "url": "chapter1.pdf"},
    {"title": "UI Design Basics", "type": "Video", "url": "ui_basics.mp4"},
  ];

  void _addMaterial() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Add Material"),
        content: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'Material Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormBuilderDropdown<String>(
                name: 'type',
                decoration: InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                items: ['PDF', 'Video', 'Link']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                initialValue: 'PDF',
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'url',
                decoration: InputDecoration(
                  labelText: 'URL or File Path',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL or path';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.saveAndValidate()) {
                setState(() {
                  //TODO
                  // materials.add(_formKey.currentState!.value);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Material added")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Learning Material")),
      body: materials.isEmpty
          ? Center(
              child: Text(
                "No materials available",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material = materials[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      material['type'] == 'PDF'
                          ? Icons.picture_as_pdf
                          : material['type'] == 'Video'
                              ? Icons.videocam
                              : Icons.link,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      material['title']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "Type: ${material['type']} • ${material['url']}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          materials.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Material deleted")),
                        );
                      },
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                    .slideX();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMaterial,
        tooltip: 'Add Material',
        child: const Icon(Icons.add),
      ),
    );
  }
}
