import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tosl_operation/modules/global.dart';

class MaterialController extends GetxController {
  var materials = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final String chapterId;

  MaterialController({required this.chapterId});

  @override
  void onInit() {
    fetchMaterials();
    super.onInit();
  }

  Future<void> fetchMaterials() async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}getMaterials.php'),
        body: {'chapterId': chapterId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          materials
              .assignAll(List<Map<String, dynamic>>.from(data['materials']));
        } else {
          Get.snackbar('Error', data['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch materials');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
