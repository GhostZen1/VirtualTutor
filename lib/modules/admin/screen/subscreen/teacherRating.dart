import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;

class TeacherRatingsPage extends StatefulWidget {
  const TeacherRatingsPage({super.key});

  @override
  State<TeacherRatingsPage> createState() => _TeacherRatingsPageState();
}

class _TeacherRatingsPageState extends State<TeacherRatingsPage> {
  List<Map<String, dynamic>> teacherRatings = [];
  bool isLoading = true;
  String errorMessage = '';

  final String apiUrl = '${ApiBase.baseUrl}getTeacherRatings.php';

  @override
  void initState() {
    super.initState();
    fetchTeacherRatings();
  }

  Future<void> fetchTeacherRatings() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          setState(() {
            teacherRatings = List<Map<String, dynamic>>.from(
                jsonData['data'].map((teacher) => {
                      'id': teacher['TeacherId'],
                      'name': teacher['teacher_name'] ?? 'Unknown Teacher',
                      'rating': double.tryParse(
                              teacher['average_rating'].toString()) ??
                          0.0,
                      'courses': teacher['courses'] ?? 'No courses assigned',
                      'totalRatings':
                          int.tryParse(teacher['total_ratings'].toString()) ??
                              0,
                    }));
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonData['error'] ?? 'Failed to load data';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    await fetchTeacherRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Ratings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: refreshData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (teacherRatings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No teacher ratings found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teacherRatings.length,
        itemBuilder: (context, index) {
          final teacher = teacherRatings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  teacher['name'][0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                teacher['name'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "Courses: ${teacher['courses']}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Based on ${teacher['totalRatings']} review(s)",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: teacher['rating'].toDouble(),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher['rating'].toStringAsFixed(1),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX();
        },
      ),
    );
  }
}
