import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewStudentReviewScreen extends StatelessWidget {
  ViewStudentReviewScreen({super.key});

  final List<Map<String, dynamic>> reviews = [
    {
      "student": "Alice Johnson",
      "rating": 4.5,
      "comment": "Great course, very engaging!",
      "date": "2025-05-10"
    },
    {
      "student": "Bob Smith",
      "rating": 4.0,
      "comment": "Good content, but needs more examples.",
      "date": "2025-05-12"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Student Reviews")),
      body: reviews.isEmpty
          ? Center(
              child: Text(
                "No reviews available",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: Text(review["student"][0]),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: Text(
                      review["student"],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                          rating: review["rating"],
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 4),
                        Text(review["comment"]),
                        Text("Posted on ${review['date']}"),
                      ],
                    ),
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
