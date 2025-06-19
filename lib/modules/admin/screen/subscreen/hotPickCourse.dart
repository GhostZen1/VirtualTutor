import 'package:tosl_operation/modules/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotPickCoursesPage extends StatefulWidget {
  const HotPickCoursesPage({super.key});

  @override
  State<HotPickCoursesPage> createState() => _HotPickCoursesPageState();
}

class _HotPickCoursesPageState extends State<HotPickCoursesPage> {
  List<Map<String, dynamic>> hotPicks = [];
  bool isLoading = true;
  String errorMessage = '';

  // Replace with your actual API URL
  final String apiUrl = '${ApiBase.baseUrl}getHotpickCourseourses.php';

  @override
  void initState() {
    super.initState();
    fetchHotPickCourses();
  }

  Future<void> fetchHotPickCourses() async {
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
            hotPicks = List<Map<String, dynamic>>.from(
                jsonData['data'].map((course) => {
                      'courseId': course['CourseID'],
                      'title': course['course_title'] ?? 'Unknown Course',
                      'category': course['Category'] ?? 'General',
                      'description':
                          course['Description'] ?? 'No description available',
                      'enrollments': int.tryParse(
                              course['total_enrollments'].toString()) ??
                          0,
                      'rating': double.tryParse(
                              course['average_rating'].toString()) ??
                          0.0,
                      'totalRatings':
                          int.tryParse(course['total_ratings'].toString()) ?? 0,
                      'rank': int.tryParse(course['rank'].toString()) ?? 1,
                      'hotScore':
                          double.tryParse(course['hot_score'].toString()) ??
                              0.0,
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
    await fetchHotPickCourses();
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey[400]!; // Silver
      case 3:
        return Colors.orange[800]!; // Bronze
      default:
        return Colors.blue;
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return "🥇";
      case 2:
        return "🥈";
      case 3:
        return "🥉";
      default:
        return "🔥";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hot Pick Courses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔥 Most Popular Courses This Month",
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 8),
            if (!isLoading && hotPicks.isNotEmpty)
              Text(
                "Based on ${hotPicks.fold<int>(0, (sum, course) => sum + (course['enrollments'] as int))} total enrollments",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ).animate().fadeIn(duration: 600.ms),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
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
              'Error loading courses',
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

    if (hotPicks.isEmpty) {
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
              'No popular courses found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView.builder(
        itemCount: hotPicks.length,
        itemBuilder: (context, index) {
          final course = hotPicks[index];
          final rank = course['rank'] as int;

          return Card(
            elevation: rank <= 3 ? 6 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: rank == 1
                  ? BorderSide(color: Colors.amber, width: 2)
                  : BorderSide.none,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getRankColor(rank),
                child: Text(
                  "#$rank",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Row(
                children: [
                  Text(_getRankEmoji(rank)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      course["title"],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight:
                                rank <= 3 ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    course["category"],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${course['enrollments']} enrollments${course['totalRatings'] > 0 ? ' • Rating: ${course['rating'].toStringAsFixed(1)} (${course['totalRatings']} reviews)' : ''}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (course['description'].isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      course['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
              trailing: rank <= 3
                  ? Icon(
                      Icons.star,
                      color: _getRankColor(rank),
                      size: 28,
                    )
                  : null,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Selected ${course['title']}"),
                    action: SnackBarAction(
                      label: 'View',
                      onPressed: () {
                        // Navigate to course details page
                        // You can implement this based on your app structure
                      },
                    ),
                  ),
                );
              },
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: (index * 100).ms)
              .slideX();
        },
      ),
    );
  }
}
