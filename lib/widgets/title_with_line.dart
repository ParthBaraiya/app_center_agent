import 'package:flutter/material.dart';

class TitleWithLine extends StatelessWidget {
  const TitleWithLine({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Divider(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
