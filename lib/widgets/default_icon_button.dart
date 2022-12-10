import 'package:flutter/material.dart';

class DefaultIconButton extends StatelessWidget {
  const DefaultIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.size,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          size: size,
        ),
      ),
    );
  }
}
