import 'dart:io';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/common/services/cloudinary_services.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/modules/blogs/features/add_update_blog/presentation/widgets/image_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});
  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  File? _selectedImage;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
        String imageUrl = '';
        if (_selectedImage != null) {
          imageUrl = await cloudinaryService.uploadImage(_selectedImage!);
        }
        if (mounted) {
          context.read<BlogBloc>().add(
            NewBlogAdded(
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
        clearForm();
        CustomSnackbar.showToastMessage(
          type: ToastType.success,
          message: 'Blog published successfully!',
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

  void clearForm() {
    _titleController.clear();
    _contentController.clear();
    _tagsController.clear();
    _selectedImage = null;
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
          "Create New Blog",
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
                        onTap: _isLoading ? null : clearForm,
                        label: 'Clear All',
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
                        label: 'Publish Blog',
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
