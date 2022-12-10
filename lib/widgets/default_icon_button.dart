import 'package:flutter/material.dart';

class DefaultIconButton extends StatelessWidget {
  const DefaultIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.size,
  }) : super(key: key);

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
