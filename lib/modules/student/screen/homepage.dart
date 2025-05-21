import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/component/card.dart';
import 'package:tosl_operation/modules/student/controlller/getUserDetail.dart';
import 'package:tosl_operation/modules/student/studentModel.dart';

class CourseHomeScreen extends StatefulWidget {
  final int userId;

  const CourseHomeScreen({super.key, required this.userId});

  @override
  State<CourseHomeScreen> createState() => _CourseHomeScreenState();
}

class _CourseHomeScreenState extends State<CourseHomeScreen> {
  late int userId;
  UserModel? userData;
  bool isLoading = true;

  final List<String> categories = ["All", "Design", "Programming", "UI/UX"];
  final String selectedCategory = "Design";

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    loadUserData();

    print("User ID: $userId");
  }

  Future<void> loadUserData() async {
    final fetchedUser = await StudentServices.fetchUserById(widget.userId);

    if (fetchedUser != null) {
      setState(() {
        userData = fetchedUser as UserModel?;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Hello, ${userData?.username ?? 'User'}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text("What do you want to learn?",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // Search
              TextField(
                decoration: InputDecoration(
                  hintText: "Search..",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("New Course!",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("User Experience Class",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            child: Text("View now",
                                style: TextStyle(color: Colors.deepPurple)),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.laptop_mac, size: 60, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Course title
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Course",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("View All", style: TextStyle(color: Colors.deepPurple)),
                ],
              ),

              const SizedBox(height: 20),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories.map((category) {
                  bool isSelected = category == selectedCategory;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.deepPurple : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              const CourseCard(
                title: "Photoshop Course",
                rating: 5.0,
                duration: "5h 15m",
                icon: Icons.camera_alt,
              ),

              const SizedBox(height: 16),

              const CourseCard(
                title: "3D Design",
                rating: 4.6,
                duration: "10h 30m",
                icon: Icons.view_in_ar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
