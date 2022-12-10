import 'package:flutter_downloader/flutter_downloader.dart';

class AppCenterAppDownloadProgress {
  final String id;
  final DownloadTaskStatus status;
  final int progress;

  const AppCenterAppDownloadProgress({
    required this.progress,
    required this.id,
    required this.status,
  });

  @override
  String toString() => '{id: $id, status: ${status.name}, progress: $progress';
}
