import 'package:app_center_agent/modules/download_list_screen/download_list_store.dart';
import 'package:app_center_agent/modules/download_list_screen/download_task/download_task_card.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/widgets/data_placeholder.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class DownloadListScreen extends StatefulWidget {
  const DownloadListScreen({super.key});

  @override
  State<DownloadListScreen> createState() => _DownloadListScreenState();
}

class _DownloadListScreenState extends State<DownloadListScreen> {
  final store = DownloadListStore();

  @override
  void initState() {
    super.initState();

    store.getDownloadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (_) {
            if (store.tasks.isEmpty) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: DefaultIconButton(
                      onTap: context.pop,
                      icon: Icons.arrow_back,
                    ),
                  ),
                  Center(
                    child: DataPlaceholder(
                      state: store.state,
                      placeholderDataMap: {
                        NetworkState.loading: const NetworkStatePlaceholderData(
                          title: 'Loading downloads',
                          subTitle: 'Please wait while we load downloads data',
                        ),
                        NetworkState.success: const NetworkStatePlaceholderData(
                          title: 'No Downloads',
                          subTitle: 'There aren\'t any running downloads',
                        ),
                        NetworkState.error: NetworkStatePlaceholderData(
                          title: 'Oops!',
                          subTitle: store.error ?? 'Something Went Wrong.',
                        ),
                      },
                    ),
                  ),
                ],
              );
            }

            return RefreshIndicator(
              onRefresh: store.getDownloadList,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(
                      'Downloads',
                      style: context.theme.textTheme.displayMedium,
                    ),
                    leading: DefaultIconButton(
                      onTap: context.pop,
                      icon: Icons.arrow_back,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => DownloadTaskCard(
                        store: store.tasks[index],
                        onDelete: () => store.removeTask(store.tasks[index]),
                      ),
                      childCount: store.tasks.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
