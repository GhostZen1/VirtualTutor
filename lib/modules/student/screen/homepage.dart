import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/component/card.dart';
import 'package:tosl_operation/modules/student/controlller/courseController.dart';
import 'package:tosl_operation/modules/student/screen/chapter.dart';
import 'package:tosl_operation/modules/student/studentModel.dart';

class CourseHomeScreen extends StatefulWidget {
  final int userId;

  const CourseHomeScreen({super.key, required this.userId});

  @override
  State<CourseHomeScreen> createState() => CourseHomeScreenState();
}

class CourseHomeScreenState extends State<CourseHomeScreen> {
  final CourseController controller = CourseController();
  final TextEditingController searchController = TextEditingController();

  UserModel? userData;
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadData();

    // Listen for changes in the search text field
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final data = await controller.loadUserAndCourses(widget.userId);
      setState(() {
        userData = data['user'];
        courses = data['courses'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  List<String> getCategories() {
    final categories =
        courses.map((course) => course['category'] as String).toSet().toList();
    return ['All', ...categories];
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'developer_board':
        return Icons.developer_board;
      case 'code':
        return Icons.code;
      case 'design_services':
        return Icons.design_services;
      default:
        return Icons.book;
    }
  }

  Future<void> _enrollInCourse(int courseId) async {
    setState(() {
      isLoading = true;
    });
    final success = await controller.enrollInCourse(widget.userId, courseId);
    setState(() {
      isLoading = false;
    });
    if (success) {
      await loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrolled successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to enroll')),
      );
    }
  }

  List<Map<String, dynamic>> getFilteredCourses() {
    return courses.where((course) {
      final categoryMatch = selectedCategory == 'All' ||
          course['category'].toString().toLowerCase() ==
              selectedCategory.toLowerCase();
      final titleMatch = course['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final teacherMatch = course['teacher']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return categoryMatch && (titleMatch || teacherMatch);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = getFilteredCourses();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
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
              TextField(
                controller: searchController,
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
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Courses",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text("View All",
                  //       style: TextStyle(color: Colors.deepPurple)),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: getCategories().map((category) {
                  final isSelected = category == selectedCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.deepPurple,
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.deepPurple),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredCourses.isEmpty
                      ? const Center(child: Text('No courses found'))
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredCourses.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            final isEnrolled = course['isEnrolled'] ?? false;
                            return CourseCard(
                              title: course['title'],
                              teacher: course['teacher'],
                              description: course['description'],
                              icon: _getIconData(course['icon']),
                              isEnrolled: isEnrolled,
                              onEnroll: () => _enrollInCourse(
                                  int.parse(course['courseId'].toString())),
                              onTap: isEnrolled
                                  ? () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChapterScreen(
                                            courseId: course['courseId'],
                                            courseTitle: course['title'],
                                          ),
                                        ),
                                      )
                                  : null,
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
