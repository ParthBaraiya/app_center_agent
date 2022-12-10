import 'package:app_center_agent/modules/release_details/app_release_details_download_store.dart';
import 'package:app_center_agent/modules/release_details/release_details_section.dart';
import 'package:app_center_agent/stores/user/organization/app/release/app_center_release_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/open_file_utility.dart';
import 'package:app_center_agent/widgets/app_center_app_bar.dart';
import 'package:app_center_agent/widgets/app_center_avatar.dart';
import 'package:app_center_agent/widgets/data_placeholder.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO: Update this page so that users can swipe to switch
//  between the releases.
class AppCenterReleaseDetailsScreen extends StatefulWidget {
  const AppCenterReleaseDetailsScreen({
    super.key,
    required this.store,
  });

  final AppCenterReleaseStore? store;

  @override
  State<AppCenterReleaseDetailsScreen> createState() =>
      _AppCenterReleaseDetailsScreenState();
}

class _AppCenterReleaseDetailsScreenState
    extends State<AppCenterReleaseDetailsScreen> {
  late final downloadStore =
      AppReleaseDetailsDownloadStore(store: widget.store);

  @override
  void initState() {
    super.initState();

    downloadStore.getDownloadStatus();

    widget.store?.getReleaseDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final appBar = AppCenterAppBar(
              action: widget.store?.details?.installUrl == null
                  ? null
                  : Observer(builder: (_) {
                      if (downloadStore.state.isLoading) {
                        return const SizedBox.shrink();
                      }

                      if ((downloadStore.downloadTask?.status.isCompleted ??
                              false) &&
                          (downloadStore.downloadTask?.fileExisted ?? false)) {
                        return DefaultIconButton(
                          onTap: () async {
                            if (downloadStore.downloadTask?.task.saveFilePath ==
                                null) return;

                            final status = await Permission
                                .requestInstallPackages
                                .request();

                            if (!status.isGranted) {
                              context.showSnackBar(
                                message: 'Permission denied!',
                              );
                              return;
                            }

                            try {
                              await OpenFileUtility.open(downloadStore
                                  .downloadTask!.task.saveFilePath!);
                            } catch (e) {
                              context.showSnackBar(message: '$e');
                            }
                          },
                          icon: Icons.open_in_new_rounded,
                        );
                      } else if (downloadStore
                              .downloadTask?.status.isEnqueued ??
                          false) {
                        return const CircularProgressIndicator();
                      } else if (downloadStore.downloadTask?.status.isPaused ??
                          false) {
                        return DefaultIconButton(
                          onTap: () {},
                          icon: Icons.refresh_rounded,
                        );
                      } else if (downloadStore.downloadTask?.status.isRunning ??
                          false) {
                        final task = downloadStore.downloadTask!;

                        return Observer(
                          builder: (_) {
                            return SizedBox.square(
                              dimension: 40,
                              child: FittedBox(
                                child: Stack(
                                  fit: StackFit.loose,
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: task.progress,
                                    ),
                                    Text(
                                      '${(task.progress * 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return DefaultIconButton(
                          onTap: downloadStore.startDownload,
                          icon: Icons.download,
                        );
                      }
                    }),
            );

            if (widget.store == null || widget.store!.details == null) {
              return Column(
                children: [
                  appBar,
                  Expanded(
                    child: Center(
                      child: DataPlaceholder(
                        state: widget.store?.state ?? NetworkState.success,
                        placeholderDataMap: {
                          NetworkState.loading:
                              const NetworkStatePlaceholderData(
                            title: 'Loading data...',
                            subTitle: 'Please wait while we load release data.',
                          ),
                          NetworkState.error: NetworkStatePlaceholderData(
                            title: 'Unable to load data',
                            subTitle: widget.store?.error ??
                                'Unable to release data. Try again after sometime',
                          ),
                          NetworkState.success:
                              const NetworkStatePlaceholderData(
                            title: 'Not Found',
                            subTitle: 'Release not found',
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return RefreshIndicator(
              onRefresh: () => widget.store!.getReleaseDetails(force: true),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBar,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Release',
                                      style:
                                          context.theme.textTheme.displaySmall,
                                    ),
                                    TextSpan(
                                      text: ' ${widget.store?.model.id ?? -1}',
                                      style:
                                          context.theme.textTheme.displaySmall,
                                    ),
                                    const TextSpan(text: '\n'),
                                    TextSpan(
                                      text:
                                          widget.store?.details?.appOs ?? 'N/A',
                                      style: context.theme.textTheme.titleLarge,
                                    ),
                                    TextSpan(
                                      text:
                                          ' ${widget.store?.details?.minOs ?? 'N/A'}'
                                          ' (${widget.store?.details?.androidMinApiLevel ?? 'N/A'})',
                                      style: context.theme.textTheme.titleLarge,
                                    ),
                                    const TextSpan(text: '\n'),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          AppCenterAvatar(
                            url: widget.store!.details?.appIconUrl ??
                                'https://via.placeholder.com/150?'
                                    'text=${(widget.store!.group.app.app.displayName)?.initials}',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReleaseDetailsSection(
                            title: 'App Name',
                            description:
                                widget.store?.details?.appDisplayName ?? 'N/A',
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: ReleaseDetailsSection(
                                  title: 'Build Version',
                                  description:
                                      widget.store?.details?.fullVersion ??
                                          'N/A',
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: ReleaseDetailsSection(
                                  title: 'Size',
                                  description:
                                      widget.store?.details?.displaySize ??
                                          'N/A',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Release Notes',
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              color: context.theme.textTheme.titleLarge?.color
                                  ?.withOpacity(0.4),
                            ),
                          ),
                          MarkdownBody(
                            data: '${widget.store?.details?.releaseNotes}',
                          ),
                          ReleaseDetailsSection(
                            title: 'Bundle Id',
                            description:
                                widget.store?.details?.bundleIdentifier ??
                                    'N/A',
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ReleaseDetailsSection(
                                  title: 'Status',
                                  description:
                                      widget.store?.details?.status ?? 'N/A',
                                ),
                              ),
                              Expanded(
                                child: ReleaseDetailsSection(
                                  title: 'Origin',
                                  description:
                                      widget.store?.details?.origin ?? 'N/A',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ReleaseDetailsSection(
                                  title: 'External?',
                                  description:
                                      (widget.store?.details?.isExternalBuild ??
                                              false)
                                          .yesOrNo,
                                ),
                              ),
                              Expanded(
                                child: ReleaseDetailsSection(
                                  title: 'Enabled?',
                                  description:
                                      (widget.store?.details?.enabled ?? false)
                                          .yesOrNo,
                                ),
                              ),
                            ],
                          ),
                          ReleaseDetailsSection(
                            title: 'Upload Date/Time',
                            description:
                                widget.store?.details?.formattedUploadDate ??
                                    'N/A',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
