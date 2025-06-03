import 'package:tosl_operation/modules/global.dart';

Future<void> openMaterial(String type, String url, BuildContext context) async {
  if (!url.startsWith('http')) {
    url = 'https://$url';
  }

  Uri materialUri = Uri.parse(url);
  print('url $materialUri');

  try {
    bool launched = await launchUrl(
      materialUri,
      mode: LaunchMode.platformDefault,
    );

    if (!launched) {
      launched = await launchUrl(
        materialUri,
        mode: LaunchMode.inAppWebView,
      );
    }

    if (!launched) {
      showError(context, 'No app found to open this material.');
    }
  } catch (e) {
    showError(context, 'Error opening material: $e');
  }
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
