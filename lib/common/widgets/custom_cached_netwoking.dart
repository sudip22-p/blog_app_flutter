import 'package:cached_network_image/cached_network_image.dart';
import 'package:blog_app/common/common.dart';
import 'package:flutter/material.dart';

//for caching images
class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeHolderImage,
    this.height,
    this.width,
    this.placeHolderFit,
    this.fit,
  });
  final String imageUrl;
  final String? placeHolderImage;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BoxFit? placeHolderFit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      // fadeInDuration: const Duration(milliseconds: 00),
      // fadeOutDuration: const Duration(milliseconds: 00),
      // placeholderFadeInDuration: const Duration(milliseconds: 00),
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      // progressIndicatorBuilder: (context, url, progress) => Image.asset(
      //   placeHolderImage ?? AssetRoutes.appLogoPng,
      //   fit: BoxFit.cover,
      // ),
      errorListener: (_) {},
      errorWidget: (context, url, error) => Image.asset(
        placeHolderImage ?? AssetRoutes.defaultAvatarImagePath,
        fit: placeHolderFit ?? BoxFit.cover,
      ),
    );
  }
}
