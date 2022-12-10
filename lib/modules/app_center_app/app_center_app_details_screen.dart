import 'package:app_center_agent/stores/user/organization/app/app_center_application_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/widgets/app_center_avatar.dart';
import 'package:app_center_agent/widgets/data_placeholder.dart';
import 'package:app_center_agent/widgets/default_card.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:app_center_agent/widgets/title_with_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class AppCenterAppDetailsScreen extends StatefulWidget {
  const AppCenterAppDetailsScreen({
    super.key,
    required this.store,
  });

  final AppCenterApplicationStore? store;

  @override
  State<AppCenterAppDetailsScreen> createState() =>
      _AppCenterAppDetailsScreenState();
}

class _AppCenterAppDetailsScreenState extends State<AppCenterAppDetailsScreen> {
  @override
  void initState() {
    super.initState();

    widget.store?.groups.listDistributionGroups();
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

    final groups = widget.store?.groups;

    return Scaffold(
      body: SafeArea(
        child: widget.store == null
            ? Column(
                children: [
                  backButton,
                  const Center(
                    child: Text('No app found.'),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: () =>
                    widget.store?.groups.listDistributionGroups() ??
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
                                    'Application',
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
                                            'application-name-${widget.store!.app.name}',
                                        child: Text(
                                          widget.store!.app.displayName ??
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
                            Observer(builder: (_) {
                              return Material(
                                type: MaterialType.transparency,
                                child: Hero(
                                  tag:
                                      'application-image-${widget.store!.app.name}',
                                  child: AppCenterAvatar(
                                    url: widget.store!.app.iconUrl ??
                                        'https://via.placeholder.com/150?'
                                            'text=${(widget.store!.app.displayName)?.initials}',
                                    dimension: 80,
                                  ),
                                ),
                              );
                            }),
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
                        child: TitleWithLine(title: 'Groups'),
                      ),
                    ),
                    Observer(builder: (_) {
                      if (groups!.groups.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: DataPlaceholder(
                              state: groups.state,
                              placeholderDataMap: {
                                NetworkState.loading:
                                    const NetworkStatePlaceholderData(
                                  subTitle:
                                      'Loading application distribution groups..',
                                ),
                                NetworkState.idle: NetworkStatePlaceholderData(
                                  subTitle:
                                      'Can not load distribution groups. Please try again later',
                                  onAction: () => groups.listDistributionGroups(
                                      force: true),
                                  actionTitle: 'Retry',
                                ),
                                NetworkState.error: NetworkStatePlaceholderData(
                                  subTitle: groups.error ??
                                      'Error loading distribution groups.',
                                  actionTitle: 'Retry',
                                  onAction: () => groups.listDistributionGroups(
                                      force: true),
                                ),
                              },
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final group = groups.groups[index];

                            return DefaultCard(
                              onTap: () {
                                context.goNamed(
                                  AppRouteData.groupDetails.name,
                                  pathParameters: {
                                    ParamName.groupName: group.group.name ?? '',
                                    ParamName.orgName:
                                        group.app.organization.name,
                                    ParamName.appName: group.app.app.name ?? '',
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          group.group.displayName ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        group.group.privacyDisplay,
                                        style:
                                            context.theme.textTheme.titleLarge,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          group.group.origin.display,
                                          style: context
                                              .theme.textTheme.titleLarge,
                                        ),
                                      ),
                                      Text(
                                        'Details >',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: groups.groups.length,
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
