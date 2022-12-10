import 'package:app_center_agent/modules/group/app_center_release_card.dart';
import 'package:app_center_agent/stores/user/organization/app/groups/app_center_app_group_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/widgets/data_placeholder.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:app_center_agent/widgets/title_with_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class AppCenterGroupDetailsScreen extends StatefulWidget {
  const AppCenterGroupDetailsScreen({
    super.key,
    required this.store,
  });

  final AppCenterAppGroupStore? store;

  @override
  State<AppCenterGroupDetailsScreen> createState() =>
      _AppCenterGroupDetailsScreenState();
}

class _AppCenterGroupDetailsScreenState
    extends State<AppCenterGroupDetailsScreen> {
  @override
  void initState() {
    super.initState();

    widget.store?.release.fetchAllReleases();
  }

  @override
  Widget build(BuildContext context) {
    final backButton = Align(
      alignment: Alignment.topLeft,
      child: DefaultIconButton(
        onTap: () => context.pop(),
        icon: Icons.arrow_back,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: widget.store == null
            ? Column(
                children: [
                  backButton,
                  const Center(
                    child: Text('No group found.'),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: () =>
                    widget.store?.release.fetchAllReleases(force: true) ??
                    Future.value(),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverToBoxAdapter(
                        child: backButton,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Distribution Group',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      top: 16,
                                    ),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Hero(
                                        tag:
                                            'distribution-group-name-${widget.store!.group.name}',
                                        child: Text(
                                          widget.store!.group.displayName ??
                                              'N/A',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 20,
                        bottom: 20,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: TitleWithLine(title: 'Releases'),
                      ),
                    ),
                    Observer(builder: (_) {
                      final releases = widget.store?.release;

                      if (releases?.releases.isEmpty ?? false) {
                        return SliverFillRemaining(
                          child: Center(
                            child: DataPlaceholder(
                              state: releases?.state ?? NetworkState.error,
                              placeholderDataMap: {
                                NetworkState.loading:
                                    const NetworkStatePlaceholderData(
                                  subTitle:
                                      'Loading application distribution groups..',
                                ),
                                NetworkState.idle: NetworkStatePlaceholderData(
                                  subTitle:
                                      'Can not load distribution groups. Please try again later',
                                  onAction: () => widget.store?.release
                                      .fetchAllReleases(force: true),
                                  actionTitle: 'Retry',
                                ),
                                NetworkState.error: NetworkStatePlaceholderData(
                                  subTitle:
                                      'Error loading distribution groups.',
                                  actionTitle: 'Retry',
                                  onAction: () => widget.store?.release
                                      .fetchAllReleases(force: true),
                                ),
                              },
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => AppCenterReleaseCard(
                            release: releases!.releases[index],
                          ),
                          childCount:
                              widget.store?.release.releases.length ?? 0,
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}
