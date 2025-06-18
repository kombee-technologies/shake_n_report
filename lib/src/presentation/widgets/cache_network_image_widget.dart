import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shake_n_report/src/core/utils/utility.dart';

class CacheNetworkImageWidget extends StatelessWidget {
  const CacheNetworkImageWidget({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fadeInDuration = const Duration(milliseconds: 1000),
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.alignment = FractionalOffset.center,
    this.fit = BoxFit.fill,
    this.placeholder,
    this.errorWidget,
    this.progressIndicatorBuilder,
    this.radius = 0,
    this.bgColor,
    this.padding,
    this.authorization,
  });

  final String imageUrl;

  final double? width;

  final double? height;

  final double radius;

  final Duration fadeInDuration;

  final Duration fadeOutDuration;

  final FractionalOffset alignment;

  final BoxFit fit;

  final Widget? placeholder;

  final Widget? errorWidget;

  final Color? bgColor;

  final EdgeInsetsGeometry? padding;

  final Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder;

  final String? authorization;

  @override
  Widget build(BuildContext context) {
    final String cacheKey = 'cache_img_${imageUrl.hashCode}';

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: bgColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        key: Key(cacheKey),
        cacheKey: cacheKey,
        cacheManager: CacheManager(
          Config(
            cacheKey,
            stalePeriod: const Duration(days: 7),
            fileSystem: IOFileSystem(cacheKey),
            // fileService: HttpFileService(),
            // fileService: SslPinningFileService(),
            // maxNrOfCacheObjects: 1,
          ),
        ),
        alignment: alignment,
        errorWidget: (BuildContext context, String error, Object stackTrace) =>
            (errorWidget == null) ? Container(color: Colors.grey) : errorWidget!,
        errorListener: (Object value) => Utility.debugLog('CacheNetworkImage: "$imageUrl" => $value'),
        placeholder: (BuildContext context, String url) =>
            (placeholder == null) ? Container(color: Colors.grey) : placeholder!,
        width: width,
        height: height,
        httpHeaders: <String, String>{
          if (authorization != null) 'Authorization': authorization ?? '',
        },
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        progressIndicatorBuilder: progressIndicatorBuilder,
      ),
    );
  }
}
