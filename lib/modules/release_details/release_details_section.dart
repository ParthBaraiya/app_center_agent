import 'package:app_center_agent/utils/extension.dart';
import 'package:flutter/material.dart';

class ReleaseDetailsSection extends StatelessWidget {
  const ReleaseDetailsSection({
    super.key,
    required this.description,
    required this.title,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: title,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color:
                    context.theme.textTheme.titleLarge?.color?.withOpacity(0.4),
              ),
            ),
            const TextSpan(text: '\n'),
            TextSpan(
              text: description,
              style: context.theme.textTheme.headlineSmall,
            )
          ],
        ),
      ),
    );
  }
}
