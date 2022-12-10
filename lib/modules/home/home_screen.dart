import 'package:app_center_agent/app_configs.dart';
import 'package:app_center_agent/modules/home/organization_tile.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/widgets/app_center_avatar.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:app_center_agent/widgets/title_with_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/data_placeholder.dart';

class HomeScreen extends StatefulObserverWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  late final listingStore = AppConfigs.users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: listingStore.currentUser == null
            ? _noUserWidget()
            : Observer(
                builder: (_) {
                  final userStore = listingStore.currentUser!;
                  if (!userStore.state.isSuccess) {
                    _loadingErrorWidget();
                  }
                  if (userStore.user == null) {
                    return _userDataFetchErrorWidget();
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        userStore.organizations.loadOrganizations(force: true),
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultIconButton(
                                    onTap: () {
                                      context.goNamed(
                                        AppRouteData.downloadsList.name,
                                      );
                                    },
                                    icon: Icons.file_download_outlined,
                                  ),
                                  const SizedBox(width: 20),
                                  DefaultIconButton(
                                    onTap: () {
                                      // TODO: Sign out user...
                                    },
                                    icon: Icons.logout_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 16,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hey There!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40,
                                          top: 16,
                                        ),
                                        child: Text(
                                          userStore.user!.displayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppCenterAvatar(
                                  url: userStore.user?.avatar ??
                                      'https://via.placeholder.com/150?text=${userStore.user!.initials}',
                                  dimension: 80,
                                ),
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
                            child: TitleWithLine(title: 'Organizations'),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 26,
                            ),
                            child: Text(
                              'This list will show only those organizations '
                              'which has at least one app.',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        Observer(
                          builder: (context) {
                            final orgs = userStore.organizations;

                            if (!orgs.state.isSuccess) {
                              return SliverFillRemaining(
                                child: _organizationListFailurePage(
                                  store: orgs,
                                  onAction: () =>
                                      orgs.loadOrganizations(force: true),
                                ),
                              );
                            }

                            if (orgs.organizations.isEmpty) {
                              return SliverFillRemaining(
                                child: _noOrganizationWidget(
                                  onReload: () =>
                                      orgs.loadOrganizations(force: true),
                                ),
                              );
                            }

                            final organizations =
                                orgs.organizations.values.toList();

                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (_, index) {
                                  final org = organizations[index]
                                    ..loadOrganization();

                                  return OrganizationTile(
                                    organization: org,
                                    index: index,
                                  );
                                },
                                childCount: orgs.organizations.length,
                              ),
                            );
                          },
                        ),
                        const SliverPadding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    AppConfigs.instance?.dispose();

    super.dispose();
  }

  Widget _organizationListFailurePage({
    required NetworkStore store,
    required VoidCallback onAction,
  }) {
    return Center(
      child: DataPlaceholder(
        state: store.state,
        placeholderDataMap: {
          NetworkState.idle: NetworkStatePlaceholderData(
            subTitle: 'Can not load organizations. Please try again later',
            actionTitle: 'Retry',
            onAction: onAction,
          ),
          NetworkState.error: NetworkStatePlaceholderData(
            subTitle: store.error ?? 'Error loading organizations...',
            actionTitle: 'Retry',
            onAction: onAction,
          ),
          NetworkState.loading: const NetworkStatePlaceholderData(
            subTitle: 'Loading organizations please wait...',
          ),
        },
      ),
    );
  }

  Widget _loadingErrorWidget() {
    return Center(
      child: DataPlaceholder(
        state: listingStore.currentUser!.state,
        placeholderDataMap: {
          NetworkState.loading: const NetworkStatePlaceholderData(
            subTitle: 'Loading user data...',
          ),
          NetworkState.idle: NetworkStatePlaceholderData(
            subTitle: 'Can not load data. Please try again later',
            onAction: listingStore.currentUser!.loadUserData,
            actionTitle: 'Retry',
          ),
          NetworkState.error: NetworkStatePlaceholderData(
            subTitle:
                listingStore.currentUser!.error ?? 'Error loading user data...',
            actionTitle: 'Login',
            onAction: () => context.goNamed(AppRouteData.login.name),
          ),
        },
      ),
    );
  }

  Widget _noUserWidget() {
    return Center(
      child: DataPlaceholder.singleState(
        state: NetworkState.error,
        child: NetworkStatePlaceholderData(
          subTitle: 'No user found.',
          actionTitle: 'Login',
          onAction: () => context.goNamed(AppRouteData.login.name),
        ),
      ),
    );
  }

  Widget _userDataFetchErrorWidget() {
    return Center(
      child: DataPlaceholder.singleState(
        state: NetworkState.error,
        child: NetworkStatePlaceholderData(
          subTitle: 'Error loading user data...',
          actionTitle: 'Login',
          onAction: () => context.goNamed(AppRouteData.login.name),
        ),
      ),
    );
  }

  Widget _noOrganizationWidget({required VoidCallback onReload}) {
    return Center(
      child: DataPlaceholder(
        state: NetworkState.error,
        placeholderDataMap: {
          NetworkState.error: NetworkStatePlaceholderData(
            subTitle: 'No organizations found!',
            onAction: onReload,
            actionTitle: 'Retry',
          ),
        },
      ),
    );
  }
}
