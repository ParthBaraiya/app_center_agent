import 'dart:async';
import 'dart:collection';

import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/modules/download_list_screen/download_task/download_task_store.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:mobx/mobx.dart';

part 'download_list_store.g.dart';

class DownloadListStore = _DownloadListStore with _$DownloadListStore;

abstract class _DownloadListStore extends NetworkStore with Store {
  final _tasks = ObservableList<DownloadTaskStore>();

  @computed
  UnmodifiableListView<DownloadTaskStore> get tasks =>
      UnmodifiableListView(_tasks);

  Future<void> getDownloadList() async {
    await networkCall(() async {
      final list = await AppConfigs.databaseRepository.getDownloadList();

      if (list.isNotEmpty) {
        await Future.wait(_tasks.map((element) => element.dispose()));
        _tasks.clear();
        _tasks.addAll(list.map((e) => DownloadTaskStore(task: e)));
      }
    });
  }

  bool removeTask(DownloadTaskStore store) {
    return _tasks.remove(store);
  }
}
