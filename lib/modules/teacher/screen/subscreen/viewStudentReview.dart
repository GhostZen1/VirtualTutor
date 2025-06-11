import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/teacher/controller/feedbackController.dart';

class ViewStudentReviewScreen extends StatefulWidget {
  final int teacherId;

  const ViewStudentReviewScreen({super.key, required this.teacherId});

  @override
  State<ViewStudentReviewScreen> createState() =>
      _ViewStudentReviewScreenState();
}

class _ViewStudentReviewScreenState extends State<ViewStudentReviewScreen> {
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  Future<void> loadReviews() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedReviews =
          await FeedbackService.getTeacherReviews(widget.teacherId);

      setState(() {
        reviews = fetchedReviews;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Reviews"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadReviews,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Error loading reviews",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadReviews,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : reviews.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.feedback_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No reviews available",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Student feedback will appear here",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: loadReviews,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  review["student"]?[0]?.toUpperCase() ?? "?",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                review["student"] ?? "Unknown Student",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  RatingBarIndicator(
                                    rating:
                                        (review["rating"] ?? 0.0).toDouble(),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review["comment"] ?? "No comment",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Posted on ${review['date'] ?? 'Unknown date'}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                  if (review['courseName'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "Course Name: ${review['courseName']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.blue.shade600,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: (index * 100).ms)
                              .slideX();
                        },
                      ),
                    ),
    );
  }
}
