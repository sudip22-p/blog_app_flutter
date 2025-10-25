import 'dart:io';
import 'package:blog_app/common/router/asset_routes.dart';
import 'package:blog_app/common/router/routes.dart';
import 'package:blog_app/common/services/cloudinary_services.dart';
import 'package:blog_app/common/widgets/buttons/app_button.dart';
import 'package:blog_app/common/widgets/custom_app_bar.dart';
import 'package:blog_app/common/widgets/custom_image_avatar.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/modules/blogs/features/add_update_blog/presentation/widgets/image_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateBlog extends StatefulWidget {
  const UpdateBlog({super.key, required this.blog});
  final Blog blog;
  @override
  State<UpdateBlog> createState() => _UpdateBlogState();
}

class _UpdateBlogState extends State<UpdateBlog> {
  late final Blog _currentBlog;
  File? _selectedImage;
  String? _currentImageUrl;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentBlog = widget.blog;
    _titleController.text = _currentBlog.title;
    _contentController.text = _currentBlog.content;
    _tagsController.text = _currentBlog.tags.join(", ");
    _currentImageUrl = _currentBlog.coverImageUrl;
  }

  void submitBlog() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) return;
        final currentUserId = currentUser.uid;
        final currentUserName = currentUser.displayName ?? 'Anonymous';
        final cloudinaryService = CloudinaryService();
        String imageUrl = _currentImageUrl ?? '';
        if (_selectedImage != null) {
          imageUrl = await cloudinaryService.uploadImage(_selectedImage!);
        }
        if (mounted) {
          context.read<BlogBloc>().add(
            BlogUpdated(
              _currentBlog.id,
              _titleController.text.trim(),
              _contentController.text.trim(),
              currentUserId,
              currentUserName,
              imageUrl,
              _tagsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
            ),
          );
        }
        CustomSnackbar.showToastMessage(
          type: ToastType.success,
          message: 'Blog updated successfully!',
        );
      } catch (e) {
        CustomSnackbar.showToastMessage(
          type: ToastType.error,
          message: 'Error publishing blog: $e',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          context.goNamed(Routes.dashboard.name);
        }
      }
    }
  }

  void resetForm() {
    _titleController.text = _currentBlog.title;
    _contentController.text = _currentBlog.content;
    _tagsController.text = _currentBlog.tags.join(", ");
    _selectedImage = null;
    _currentImageUrl = _currentBlog.coverImageUrl;
    setState(() {});
    CustomSnackbar.showToastMessage(
      type: ToastType.success,
      message: 'Form Reset Done!',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          "Update Blog",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.customTheme.surface,
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              Text(
                'Blog Information',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              AppGaps.gapH40,

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Title',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AppGaps.gapH4,

              TextFormField(
                style: context.textTheme.bodyMedium,
                maxLines: 1,
                controller: _titleController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                validator: (value) => Validators.checkFieldEmpty(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title Here ',
                  hintStyle: context.textTheme.bodyMedium,
                ),
              ),

              AppGaps.gapH12,

              ImagePickerWidget(
                onImageSelected: (file) {
                  _selectedImage = file;
                },
              ),

              AppGaps.gapH12,

              // Showing current image if exists and no new image selected
              if (_currentImageUrl != null && _selectedImage == null)
                Column(
                  children: [
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: AppBorderRadius.chipBorderRadius,
                        border: Border.all(color: context.customTheme.outline),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: AppBorderRadius.chipRadius,
                          topRight: AppBorderRadius.chipRadius,
                        ),

                        child: CustomImageAvatar(
                          imageUrl: widget.blog.coverImageUrl!,
                          shape: AvatarShape.rectangle,
                          width: double.infinity,
                          height: double.infinity,
                          placeHolderImage:
                              AssetRoutes.defaultPlaceholderImagePath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    AppGaps.gapH4,

                    Text(
                      "Current image (select new image to replace)",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.customTheme.contentPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

              AppGaps.gapH24,

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Tags Separated by Commas',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AppGaps.gapH4,

              TextFormField(
                style: context.textTheme.bodyMedium,
                maxLines: 2,
                controller: _tagsController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final tags = value.split(',').map((e) => e.trim());
                    if (tags.length > 10) {
                      return 'Maximum 10 tags allowed';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'E.g: technology, latest, ai, etc',
                  hintStyle: context.textTheme.bodyMedium,
                ),
              ),

              AppGaps.gapH40,

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Blog Content',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AppGaps.gapH4,

              TextFormField(
                style: context.textTheme.bodyMedium,
                maxLines: 12,
                controller: _contentController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter blog content';
                  }
                  if (value.trim().length < 50) {
                    return 'Content must be at least 50 characters long';
                  }
                  return null;
                },

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Your Blog Content Goes here ...',
                  hintStyle: context.textTheme.bodyMedium,
                ),
              ),

              AppGaps.gapH24,

              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton.outlined(
                        onTap: _isLoading ? null : resetForm,
                        label: 'Reset Changes',
                        textColor: context.customTheme.info,
                        border: Border.all(
                          color: context.customTheme.info,
                          width: AppSpacing.xxs,
                        ),
                        borderRadius: AppBorderRadius.mediumBorderRadius,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        icon: Icon(
                          Icons.close_outlined,
                          color: context.customTheme.info,
                        ),
                        gap: AppGaps.gapW8,
                        iconPosition: IconAlignment.start,
                      ),
                    ),

                    AppGaps.gapW16,

                    Expanded(
                      child: CustomButton.outlined(
                        onTap: _isLoading ? null : submitBlog,
                        label: 'Update Blog',
                        textColor: context.customTheme.success,
                        border: Border.all(
                          color: context.customTheme.success,
                          width: AppSpacing.xxs,
                        ),
                        borderRadius: AppBorderRadius.mediumBorderRadius,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        icon: Icon(
                          Icons.save_outlined,
                          color: context.customTheme.success,
                        ),
                        gap: AppGaps.gapW8,
                        iconPosition: IconAlignment.start,
                      ),
                    ),
                  ],
                ),
              ),

              AppGaps.gapH64,
            ],
          ),
        ),
      ),
    );
  }
}
