import 'package:tosl_operation/modules/global.dart';

class TeacherHomeScreen extends StatelessWidget {
  final int userId;

  const TeacherHomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/teacher_avatar.png'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search courses or students...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _filterButton(Icons.menu_book, "My Courses", Colors.blue),
                  _filterButton(Icons.feedback, "Feedback", Colors.orange),
                  _filterButton(Icons.bar_chart, "Analytics", Colors.green),
                ],
              ),
              const SizedBox(height: 20),

              // Section Title
              // const Text(
              //   "Your Courses",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 12),

              // // Horizontal Course Cards
              // SizedBox(
              //   height: 150,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       _courseCard(
              //         title: "UI/UX Mastery",
              //         description: "32 students enrolled",
              //         color: Colors.lightBlueAccent,
              //       ),
              //       _courseCard(
              //         title: "Flutter Bootcamp",
              //         description: "21 students enrolled",
              //         color: Colors.orangeAccent,
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),

              // New Modules Section
              const Text(
                "Teacher Modules",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _moduleCard(
                        context, Icons.people, "View Student List + Progress"),
                    _moduleCard(
                        context, Icons.book, "Manage Learning Material"),
                    _moduleCard(context, Icons.quiz, "Manage Quiz / Activity"),
                    _moduleCard(
                        context, Icons.show_chart, "Track Student Progress"),
                    _moduleCard(context, Icons.reviews, "View Student Review"),
                    _moduleCard(context, Icons.analytics,
                        "Analyze Student Performance"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _filterButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  static Widget _courseCard({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school, color: Colors.white, size: 30),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _moduleCard(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to the detailed page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label tapped')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
