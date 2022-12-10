import 'package:app_center_agent/utils/extension.dart';
import 'package:flutter/material.dart';

class DefaultCard extends StatelessWidget {
  const DefaultCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 14,
    ),
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: margin,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
