import 'dart:async';
import 'dart:io';

import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/utils/downloader/database/schema/app_download_schema.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mobx/mobx.dart';

part 'download_task_store.g.dart';

class DownloadTaskStore = _DownloadTaskStore with _$DownloadTaskStore;

abstract class _DownloadTaskStore extends NetworkStore with Store {
  _DownloadTaskStore({
    required this.task,
  }) {
    _loadTask();

    if (task.saveFilePath == null) {
      _fileExisted = false;
    } else {
      final file = File(task.saveFilePath!);

      _fileExisted = file.existsSync();

      file.watch().listen((event) {
        _fileExisted = file.existsSync();
      });
    }
  }

  final AppDownloadData task;

  // NOTE (parth): Using timer is a temporary implementation that we used.
  // Because flutter_downloader package is not calling the isolate method
  // to send the download progress as frequently.
  //
  Timer? _timer;

  // StreamSubscription? _subscription;

  StreamSubscription? _fileWatchSubscription;

  @observable
  double _progress = 0;

  @observable
  DownloadTaskStatus _status = DownloadTaskStatus.undefined;

  @computed
  double get progress => _progress;

  @computed
  DownloadTaskStatus get status => _status;

  @observable
  bool _fileExisted = true;

  @computed
  bool get fileExisted => _fileExisted;

  Future<void> dispose() async {
    // _subscription?.cancel() ?? Future.value();

    _cancelTimer();
    await _fileWatchSubscription?.cancel();
  }

  Future<void> _loadTask() {
    if (task.taskId == null) return Future.value();

    return networkCall(() async {
      final downloadTask = await FlutterDownloader.loadTasksWithRawQuery(
        query: 'SELECT * FROM task where task_id="${task.taskId}"',
      );

      if (downloadTask?.isNotEmpty ?? false) {
        final task = downloadTask!.first;

        _status = task.status;
        _progress = task.progress / 100;
        // _subscription = AppConfigs.downloader.listen(
        //   taskId: task.taskId,
        //   onProgress: _onProgress,
        // );

        _saveStatus();

        _timer ??=
            Timer.periodic(const Duration(seconds: 2), (timer) => _loadTask());

        if ([3, 4, 5, 6].contains(task.status.index)) {
          _cancelTimer();
        }
      } else {
        _cancelTimer();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // void _onProgress(AppCenterAppDownloadProgress downloadProgress) {
  //   _progress = downloadProgress.progress / 100;
  //   _saveStatus();
  //
  //   _status = downloadProgress.status;
  // }

  Future<void> _saveStatus() async {
    if (_status.index != task.status) {
      task.status = _status.index;
      await AppConfigs.databaseRepository.saveDownload(task);
    }
  }
}
