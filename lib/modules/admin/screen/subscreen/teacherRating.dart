import 'package:tosl_operation/modules/global.dart';

class TeacherRatingsPage extends StatelessWidget {
  final List<Map<String, dynamic>> teacherRatings = [
    {'name': 'John Doe', 'rating': 4.9, 'courses': 'Math, Physics'},
    {'name': 'Jane Smith', 'rating': 4.8, 'courses': 'English, Literature'},
    {'name': 'Michael Lee', 'rating': 4.7, 'courses': 'Chemistry, Biology'},
  ];

  TeacherRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Ratings")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teacherRatings.length,
        itemBuilder: (context, index) {
          final teacher = teacherRatings[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(teacher['name'][0],
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(teacher['name'],
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text("Courses: ${teacher['courses']}",
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: RatingBarIndicator(
                rating: teacher['rating'].toDouble(),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX();
        },
      ),
    );
  }
}
