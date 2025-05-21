import 'package:tosl_operation/modules/global.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final double rating;
  final String duration;
  final IconData icon;

  const CourseCard({
    super.key,
    required this.title,
    required this.rating,
    required this.duration,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 50, color: Colors.deepPurple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(rating.toString(),
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    const Icon(Icons.schedule, size: 16, color: Colors.black87),
                    Text(duration, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
