import 'package:app_center_agent/stores/user/organization/app/release/app_center_release_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/widgets/default_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppCenterReleaseCard extends StatelessWidget {
  const AppCenterReleaseCard({
    super.key,
    required this.release,
  });

  final AppCenterReleaseStore release;

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      onTap: () {
        context.goNamed(AppRouteData.releaseDetails.name, pathParameters: {
          ParamName.releaseId: '${release.model.id ?? -1}',
          ParamName.groupName: release.group.group.name ?? '',
          ParamName.appName: release.group.app.app.name ?? '',
          ParamName.orgName: release.group.app.organization.name,
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  release.model.fullVersion,
                  style: context.theme.textTheme.headlineMedium,
                ),
              ),
              Text(
                '${release.model.id ?? -1}',
                style: context.theme.textTheme.titleLarge?.copyWith(
                  color: context.theme.textTheme.titleLarge?.color
                      ?.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  release.model.formattedUploadDate,
                  style: context.theme.textTheme.titleLarge,
                ),
              ),
              Text(
                'Details >',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          )
        ],
      ),
    );
  }
}
