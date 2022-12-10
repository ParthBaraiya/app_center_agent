import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCenterAvatar extends StatelessWidget {
  const AppCenterAvatar({
    super.key,
    required this.url,
    this.dimension = 74,
  });

  final String url;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        image: DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      child: SizedBox(
        height: dimension,
        width: dimension,
      ),
    );
  }
}
