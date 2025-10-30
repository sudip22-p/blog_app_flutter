import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter/material.dart';

class CoverImageSection extends StatefulWidget {
  final BlogEntity blog;

  const CoverImageSection({super.key, required this.blog});

  @override
  State<CoverImageSection> createState() => CoverImageSectionState();
}

class CoverImageSectionState extends State<CoverImageSection> {
  bool? isFavouriteBlog;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: AppBorderRadius.chipRadius,
              topRight: AppBorderRadius.chipRadius,
            ),

            child: CustomImageAvatar(
              imageUrl: widget.blog.coverImageUrl,
              shape: AvatarShape.rectangle,
              width: double.infinity,
              height: double.infinity,
              placeHolderImage: AssetRoutes.defaultPlaceholderImagePath,
            ),
          ),

          // favorite button
          Positioned(
            top: 4,
            right: 8,
            child: FavouriteToggle(blog: widget.blog),
          ),
        ],
      ),
    );
  }
}
