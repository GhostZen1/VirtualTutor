import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/global.dart';
import 'package:tosl_operation/modules/student/studentModel.dart';

class CourseController extends GetxController {
  var courseList = <Map<String, dynamic>>[].obs;
  var filteredCourseList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final String currentUserId;

  CourseController({required this.currentUserId});

  @override
  void onInit() {
    fetchCourses();
    super.onInit();
  }

  Future<void> fetchCourses() async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}getCourses.php'),
        body: {'userId': currentUserId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Add default category if missing
          final courses = List<Map<String, dynamic>>.from(data['courses'])
              .map((course) => {
                    ...course,
                    'category': course['category'] ?? 'Uncategorized',
                  })
              .toList();
          courseList.assignAll(courses);
          filteredCourseList.assignAll(courses);
        } else {
          Get.snackbar('Error', data['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch courses');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      filteredCourseList.assignAll(courseList);
    } else {
      filteredCourseList.assignAll(
        courseList
            .where((course) =>
                course['title'].toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}getUser.php'),
        body: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return UserModel(
            username: data['user']['username'] ?? 'User',
            email: '',
            role: '',
          );
        } else {
          throw data['message'];
        }
      } else {
        throw 'Failed to fetch user';
      }
    } catch (e) {
      throw 'Error fetching user: $e';
    }
  }

  void addDummyCourse() {
    courseList.add({
      'title': 'Dummy Course',
      'total': '0',
      'courseId': (courseList.length + 1).toString(),
      'icon': 'icons.bug_report',
      'category': 'Uncategorized',
    });
    filteredCourseList.assignAll(courseList);
  }

  void updateCourseTitle(int index, String newTitle) {
    final course = courseList[index];
    courseList[index] = {
      ...course,
      'title': newTitle,
    };
    filteredCourseList.assignAll(courseList);
  }
}

class ProgressController extends GetxController {
  var progressData = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  Future<void> fetchProgressData() async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}getStudentProgress.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          progressData
              .assignAll(List<Map<String, dynamic>>.from(data['progress']));
        } else {
          Get.snackbar('Error', data['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch progress data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
