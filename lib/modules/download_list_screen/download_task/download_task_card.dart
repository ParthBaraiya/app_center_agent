import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/modules/download_list_screen/download_task/download_task_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/open_file_utility.dart';
import 'package:app_center_agent/widgets/default_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadTaskCard extends StatefulWidget {
  const DownloadTaskCard({
    super.key,
    required this.store,
    this.onDelete,
  });

  final DownloadTaskStore store;
  final VoidCallback? onDelete;

  @override
  State<DownloadTaskCard> createState() => _DownloadTaskCardState();
}

class _DownloadTaskCardState extends State<DownloadTaskCard> {
  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Observer(
                  builder: (_) {
                    return Text(
                      widget.store.task.saveFileName ??
                          widget.store.task.fileName() ??
                          'N/A',
                      style: TextStyle(
                        decoration: !widget.store.status.isCompleted ||
                                widget.store.fileExisted
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    );
                  },
                ),
              ),
              Observer(
                builder: (_) {
                  if (widget.store.status.isRunning ||
                      widget.store.status.isEnqueued ||
                      widget.store.status.isPaused) {
                    return const SizedBox.shrink();
                  }

                  return InkWell(
                    onTap: () async {
                      if (widget.store.status.isCompleted &&
                          widget.store.fileExisted &&
                          widget.store.task.saveFilePath != null) {
                        final status =
                            await Permission.requestInstallPackages.request();

                        if (!status.isGranted) {
                          context.showSnackBar(
                            message: 'Permission denied!',
                          );
                          return;
                        }

                        try {
                          await OpenFileUtility.open(
                              widget.store.task.saveFilePath!);
                        } catch (e) {
                          context.showSnackBar(message: '$e');
                        }
                      } else {
                        AppConfigs.databaseRepository
                            .deleteDownload(widget.store.task);
                        widget.onDelete?.call();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: widget.store.status.isCompleted &&
                              widget.store.fileExisted
                          ? const Icon(
                              Icons.open_in_new,
                            )
                          : const Icon(
                              Icons.delete_outline_rounded,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
          Observer(
            builder: (_) {
              return Row(
                children: [
                  Expanded(
                    child: widget.store.status.isRunning
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: LinearProgressIndicator(
                              value: widget.store.progress,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Text(
                    widget.store.status.isRunning
                        ? '${(widget.store.progress * 100).toStringAsFixed(0)}%'
                        : widget.store.status.name.toUpperCase(),
                    style: context.theme.textTheme.headlineMedium?.copyWith(
                      color: widget.store.status.color,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
