import 'package:app_center_agent/utils/extension.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppCenterAppBar extends StatelessWidget {
  const AppCenterAppBar({
    super.key,
    this.title,
    this.action,
  });

  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          DefaultIconButton(
            onTap: () => context.pop(),
            icon: Icons.arrow_back,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title ?? '',
              style: context.theme.textTheme.displayMedium,
            ),
          ),
          const SizedBox(width: 20),
          if (action != null) action!,
        ],
      ),
    );
  }
}
