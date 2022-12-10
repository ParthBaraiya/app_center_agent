// ignore_for_file: prefer_initializing_formals

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

part 'app_download_schema.g.dart';

// TODO (parth): Move this to extensions.
extension FileNameExtension on String {
  String get fileName => path.basename(this);
}

@collection
class AppDownloadData {
  Id id = Isar.autoIncrement;

  String? taskId;
  String? appName;
  int? releaseId;
  String? organization;
  String? downloadUrl;
  int status = DownloadTaskStatus.undefined.index;
  String? saveFilePath;

  String? get saveFileName => saveFilePath?.fileName;

  @ignore
  bool _isFromCreate = false;

  @ignore
  bool get isFromCreate => _isFromCreate;

  AppDownloadData();

  AppDownloadData.create({
    required String appName,
    required int releaseId,
    required String organization,
    required String downloadUrl,
  })  : appName = appName,
        releaseId = releaseId,
        organization = organization,
        downloadUrl = downloadUrl,
        _isFromCreate = true;

  String? fileName([int? counter]) {
    if (downloadUrl == null || appName == null || releaseId == null) return '';
    final url = downloadUrl!;

    final extension = path.extension(Uri.parse(url).pathSegments.last);

    return '${appName}_$releaseId ${counter == null ? '' : '($counter)'}$extension';
  }
}
