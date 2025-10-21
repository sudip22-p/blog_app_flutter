import 'package:blog_app/common/router/asset_routes.dart';
import 'package:blog_app/common/widgets/custom_image_avatar.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/features/favourites/presentation/views/favourtite_toggle_box.dart';
import 'package:flutter/material.dart';

class CoverImageSection extends StatefulWidget {
  final Blog blog;

  const CoverImageSection({super.key, required this.blog});

  @override
  State<CoverImageSection> createState() => CoverImageSectionState();
}

class CoverImageSectionState extends State<CoverImageSection> {
  bool? isFavouriteBlog;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.blog.coverImageUrl == null) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: AppBorderRadius.chipRadius,
              topRight: AppBorderRadius.chipRadius,
            ),

            child: CustomImageAvatar(
              imageUrl: widget.blog.coverImageUrl!,
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
