import 'package:flutter/material.dart';

class CacheNetworkImageWidget extends StatelessWidget {
  const CacheNetworkImageWidget({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.radius = 0,
    this.bgColor,
    this.padding,
  });

  final String imageUrl;

  final double? width;

  final double? height;

  final double radius;

  final BoxFit fit;

  final Color? bgColor;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl,
          fit: fit,
          width: width,
          height: height,
        ),
      );
}
