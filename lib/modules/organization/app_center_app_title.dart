import 'package:app_center_agent/stores/user/organization/app/app_center_application_store.dart';
import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/widgets/app_center_avatar.dart';
import 'package:app_center_agent/widgets/default_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppCenterAppTile extends StatelessWidget {
  const AppCenterAppTile({
    super.key,
    required this.app,
  });

  final AppCenterApplicationStore app;

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      onTap: () {
        context.goNamed(AppRouteData.applicationDetails.name, pathParameters: {
          ParamName.appName: app.app.name ?? '',
          ParamName.orgName: app.organization.name,
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            type: MaterialType.transparency,
            child: Hero(
              tag: 'application-image-${app.app.name}',
              child: AppCenterAvatar(
                url: app.app.iconUrl ??
                    'https://via.placeholder.com/150?text='
                        '${(app.app.displayName ?? 'N/A').initials}',
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: Hero(
                    tag: 'application-name-${app.app.name}',
                    child: Text(
                      '${app.app.displayName ?? 'N/A'}\n\n',
                      style: context.theme.textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      '${app.app.os}',
                      style: context.theme.textTheme.headlineSmall,
                    )),
                    Text(
                      'Details >',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
