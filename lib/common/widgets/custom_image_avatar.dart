import 'package:flutter/material.dart';
import 'package:blog_app/common/common.dart';

enum AvatarShape { circle, rectangle }

class CustomImageAvatar extends StatelessWidget {
  const CustomImageAvatar({
    super.key,
    required this.imageUrl,
    this.size,
    this.height,
    this.width,
    this.shape = AvatarShape.circle,
    this.placeHolderImage,
    this.fit = BoxFit.cover,
    this.placeHolderFit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final double? size;
  final double? height;
  final double? width;
  final AvatarShape shape;
  final String? placeHolderImage;
  final BoxFit fit;
  final BoxFit placeHolderFit;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final double finalHeight = size ?? height ?? 50;
    final double finalWidth = size ?? width ?? 50;

    return Container(
      height: finalHeight,
      width: finalWidth,
      decoration: BoxDecoration(
        shape: shape == AvatarShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: shape == AvatarShape.rectangle
            ? borderRadius ?? BorderRadius.circular(12)
            : null,
      ),
      clipBehavior: Clip.hardEdge,

      child: CustomCachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeHolderImage: placeHolderImage,
        placeHolderFit: placeHolderFit,
      ),
    );
  }
}
