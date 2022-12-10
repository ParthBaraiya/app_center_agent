import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user/organization/organization_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/widgets/app_center_avatar.dart';
import 'package:app_center_agent/widgets/default_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../utils/enums.dart';
import '../../widgets/data_placeholder.dart';

class OrganizationTile extends StatelessWidget {
  const OrganizationTile({
    super.key,
    required this.organization,
    required this.index,
  });

  final OrganizationStore organization;
  final int index;

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      onTap: () => context.goNamed(
        AppRouteData.organizationDetails.name,
        pathParameters: {
          ParamName.orgName: organization.name,
        },
      ),
      child: Observer(
        builder: (_) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: organization.state.isSuccess &&
                    organization.organization != null
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  type: MaterialType.transparency,
                                  child: Hero(
                                    tag:
                                        'organization-name-tag-${organization.name}',
                                    child: Text(
                                      organization.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (organization.organization!.createdDate !=
                                    null)
                                  Text(
                                    'Created: ${organization.organization!.createdDate!.formatted}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: const Color(0xFFB3B3B3),
                                        ),
                                  ),
                                if (organization.organization!.updatedDate !=
                                    null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'Modified: ${organization.organization!.updatedDate!.formatted}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: const Color(0xFFB3B3B3),
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: Hero(
                              tag:
                                  'organization-image-tag-${organization.name}',
                              child: AppCenterAvatar(
                                url: organization.organization!.avatar ??
                                    'https://via.placeholder.com/150?text='
                                        '${organization.organization!.initials}',
                                dimension: 80,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              organization.organization!.origin.mappingString
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              child: Text(
                                'Details >',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : _organizationDataFetchFailWidget(organization),
          );
        },
      ),
    );
  }

  Widget _organizationDataFetchFailWidget(NetworkStore store) {
    return DataPlaceholder(
      state: organization.state,
      placeholderDataMap: {
        NetworkState.error: NetworkStatePlaceholderData(
          title: organization.displayName,
          subTitle: organization.error ?? 'Error loading organization data.',
        ),
        NetworkState.loading: NetworkStatePlaceholderData(
          title: organization.displayName,
          subTitle: 'Loading organization data...',
        ),
      },
    );
  }
}
