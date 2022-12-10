import 'package:app_center_agent/modules/organization/app_center_app_title.dart';
import 'package:app_center_agent/stores/user/organization/organization_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/values/app_strings.dart';
import 'package:app_center_agent/widgets/app_center_avatar.dart';
import 'package:app_center_agent/widgets/data_placeholder.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:app_center_agent/widgets/title_with_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class OrganizationDetailsScreen extends StatelessWidget {
  const OrganizationDetailsScreen({
    super.key,
    required this.store,
  });

  final OrganizationStore? store;

  @override
  Widget build(BuildContext context) {
    late final organization = store;

    return Scaffold(
      body: SafeArea(
        child: organization == null
            ? Center(
                child: Text(
                  'Organization not found.',
                  style: context.theme.textTheme.displayMedium,
                ),
              )
            : Observer(
                builder: (_) {
                  final backButton = Align(
                    alignment: Alignment.topLeft,
                    child: DefaultIconButton(
                      onTap: () => context.pop(),
                      icon: Icons.arrow_back,
                    ),
                  );

                  if (organization.organization == null) {
                    return Column(
                      children: [
                        backButton,
                        Center(
                          child: DataPlaceholder(
                            state: organization.state,
                            placeholderDataMap: {
                              NetworkState.success:
                                  const NetworkStatePlaceholderData(
                                subTitle: 'Organization not found',
                                title: 'Not Found',
                              ),
                              NetworkState.error: NetworkStatePlaceholderData(
                                subTitle: organization.error ??
                                    AppStrings.somethingWentWrong,
                                title: 'Error fetching data',
                              ),
                              NetworkState.loading:
                                  const NetworkStatePlaceholderData(
                                subTitle: 'Loading organization data.',
                                title: 'Loading...',
                              ),
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  // TODO: Use flexible AppBar here...
                  return CustomScrollView(
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
                                      'Organization',
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
                                              'organization-name-tag-${organization.name}',
                                          child: Text(
                                            organization.displayName,
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
                                        'organization-image-tag-${organization.name}',
                                    child: AppCenterAvatar(
                                      url: organization.organization?.avatar ??
                                          'https://via.placeholder.com/150?'
                                              'text=${(organization.displayName).initials}',
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
                          child: TitleWithLine(title: 'Applications'),
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          final apps = organization.apps;

                          // if (apps == null) {
                          //   return const SliverToBoxAdapter(
                          //       child: Text("No apps found"));
                          // }

                          if (apps.apps.isNotEmpty) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final app = apps.apps[index];

                                  return AppCenterAppTile(
                                    app: app,
                                  );
                                },
                                childCount: apps.apps.length,
                              ),
                            );
                          }

                          return SliverFillRemaining(
                            child: DataPlaceholder(
                              state: apps.state,
                              placeholderDataMap: {
                                NetworkState.error: NetworkStatePlaceholderData(
                                  title: 'Error fetching apps',
                                  subTitle: apps.error,
                                ),
                                NetworkState.success:
                                    NetworkStatePlaceholderData(
                                  title: 'No Apps',
                                  subTitle: apps.error,
                                ),
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
