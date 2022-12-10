import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app_center_agent/utils/downloader/database/download_database_repository.dart';
import 'package:app_center_agent/utils/downloader/database/schema/app_download_schema.dart';
import 'package:app_center_agent/utils/downloader/download_progress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

const downloadProgressPortName = 'downloader_send_port';

typedef DownloadProgressListener = void Function(AppCenterAppDownloadProgress);

class FileDownloaderUtility {
  final DownloadDatabaseRepository repository;

  FileDownloaderUtility({
    required this.repository,
  });

  final _port = ReceivePort();

  final _progress = <String, StreamController<AppCenterAppDownloadProgress>>{};

  Future<void> init() async {
    _port.listen((data) {
      if (data is AppCenterAppDownloadProgress) _onDownloadProgress(data);
    }, onDone: () {
      debugPrint('Receive port is closed...');
    });

    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      downloadProgressPortName,
    );

    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);

    try {
      await FlutterDownloader.registerCallback(downloadCallback);
      debugPrint('Initialized...');
    } catch (e) {
      debugPrint('$e');
    }
  }

  /// Starts a new download from [downloadConfigs].
  ///
  /// In order to start a download from [downloadConfigs], Object must be created
  /// using [AppDownloadData.create] constructor else this method will throw
  /// error.
  ///
  /// If everything works as expected and download starts, and
  /// [AppDownloadData.taskId] will get populated.
  ///
  Future<AppDownloadData> startAppDownload({
    required AppDownloadData downloadConfigs,
    bool force = false,
  }) async {
    if (!downloadConfigs.isFromCreate) {
      throw 'Invalid download configs';
    }

    try {
      final downloads = await path_provider.getDownloadsDirectory();
      if (downloads == null) throw 'Directory not found';

      final saveDir = Directory(path.join(downloads.path, 'applications'));

      if (!saveDir.existsSync()) {
        saveDir.createSync(recursive: true);
      }

      String fileName;
      File file;
      int? count;

      do {
        fileName = downloadConfigs.fileName(count)!;
        file = File(path.join(saveDir.path, fileName));

        count = (count ?? 0) + 1;

        if (!force && file.existsSync()) {
          throw 'File already downloaded.';
        }
      } while (file.existsSync());

      downloadConfigs.saveFilePath = file.path;

      downloadConfigs.taskId = await FlutterDownloader.enqueue(
        url: downloadConfigs.downloadUrl!,
        savedDir: saveDir.path,
        requiresStorageNotLow: true,
        fileName: path.basename(file.path),
      );

      await repository.saveDownload(downloadConfigs);
      return downloadConfigs;
    } catch (e) {
      throw 'Something went wrong!';
    }
  }

  Future<String?> resumeDownload(String downloadTaskId) {
    return FlutterDownloader.resume(taskId: downloadTaskId);
  }

  Future<void> pauseDownload(String downloadTaskId) {
    return FlutterDownloader.pause(taskId: downloadTaskId);
  }

  Future<void> openDownload(String downloadTaskId) {
    return FlutterDownloader.open(taskId: downloadTaskId);
  }

  Future<void> cancelDownload(String downloadTaskId) {
    return FlutterDownloader.cancel(taskId: downloadTaskId);
  }

  StreamSubscription<AppCenterAppDownloadProgress> listen({
    required String taskId,
    required DownloadProgressListener onProgress,
  }) {
    if (_progress[taskId] == null) {
      _progress[taskId] = StreamController.broadcast();
    }

    return _progress[taskId]!.stream.listen(onProgress);
  }

  Future<void> dispose() async {
    IsolateNameServer.removePortNameMapping(downloadProgressPortName);
    _port.close();
    await Future.wait(_progress.values.map((e) => e.close()));
  }

  void _onDownloadProgress(AppCenterAppDownloadProgress progress) {
    _progress[progress.id]?.add(progress);
  }
}

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final send = IsolateNameServer.lookupPortByName(downloadProgressPortName);
  if (send == null) return;

  send.send(AppCenterAppDownloadProgress(
    progress: progress,
    id: id,
    status: DownloadTaskStatus.fromInt(status),
  ));
}
