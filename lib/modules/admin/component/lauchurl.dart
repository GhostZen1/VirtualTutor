import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> requestPermissions() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    return true;
  } else {
    return false;
  }
}

Future<void> downloadAndOpenFile(String url, String filename) async {
  bool granted = await requestPermissions();
  if (!granted) {
    print("Storage permission denied");
    return;
  }

  // Prepare directory to save file
  final directory = await getExternalStorageDirectory();
  final savePath = '${directory!.path}/$filename';

  // Start download task
  final taskId = await FlutterDownloader.enqueue(
    url: url,
    savedDir: directory.path,
    fileName: filename,
    showNotification: true, // Show download progress in notification bar
    openFileFromNotification: true, // Click notification to open file
  );

  // Optionally listen for task completion events (advanced)
  // When completed, you can open file manually:
  // await OpenFile.open(savePath);
}
