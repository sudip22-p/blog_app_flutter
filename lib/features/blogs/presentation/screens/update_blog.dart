import 'dart:io';
import 'package:blog_app/core/services/cloudinary_services.dart';
import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blogs/presentation/widgets/form_widgets.dart';
import 'package:blog_app/features/blogs/presentation/widgets/image_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateBlog extends StatefulWidget {
  const UpdateBlog({super.key, required this.blogId, required this.blogs});
  final String blogId;
  final List<Blog> blogs;
  @override
  State<UpdateBlog> createState() => _UpdateBlogState();
}

class _UpdateBlogState extends State<UpdateBlog> {
  late final Blog currentBlog;
  File? selectedImage;
  String? currentImageUrl;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentBlog = widget.blogs.firstWhere((blog) => blog.id == widget.blogId);
    _titleController.text = currentBlog.title;
    _contentController.text = currentBlog.content;
    _tagsController.text = currentBlog.tags.join(", ");
    currentImageUrl = currentBlog.coverImageUrl;
  }

  void submitBlog() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) return;
        final currentUserId = currentUser.uid;
        final currentUserName = currentUser.displayName ?? 'Anonymous';
        final cloudinaryService = CloudinaryService();
        String imageUrl = currentImageUrl ?? '';
        // Upload new image to Cloudinary if image was changed
        if (selectedImage != null) {
          imageUrl = await cloudinaryService.uploadImage(selectedImage!);
        }
        if (mounted) {
          context.read<BlogBloc>().add(
            BlogUpdated(
              currentBlog.id,
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blog updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating blog: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void resetForm() {
    _titleController.text = currentBlog.title;
    _contentController.text = currentBlog.content;
    _tagsController.text = currentBlog.tags.join(", ");
    selectedImage = null;
    currentImageUrl = currentBlog.coverImageUrl;
    setState(() {});
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Blog'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Blog Info Section
              FormSection(
                title: 'Blog Information',
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _titleController,
                      labelText: 'Title',
                      hintText: 'Enter your blog title',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.trim().length < 3) {
                          return 'Title must be at least 3 characters long';
                        }
                        return null;
                      },
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    ImagePickerWidget(
                      onImageSelected: (file) {
                        setState(() {
                          selectedImage = file;
                        });
                      },
                    ),
                    // Show current image if exists and no new image selected
                    if (currentImageUrl != null && selectedImage == null)
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                currentImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Current image (select new image to replace)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _tagsController,
                      labelText: 'Tags',
                      hintText:
                          'Enter tags separated by commas (e.g., technology, programming, tutorial)',
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final tags = value.split(',').map((e) => e.trim());
                          if (tags.length > 10) {
                            return 'Maximum 10 tags allowed';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Content Section
              FormSection(
                title: 'Content',
                child: CustomTextFormField(
                  controller: _contentController,
                  labelText: 'Blog Content',
                  hintText: 'Write your blog content here...',
                  maxLines: 15,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter blog content';
                    }
                    if (value.trim().length < 50) {
                      return 'Content must be at least 50 characters long';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(color: theme.dividerColor, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : resetForm,
                        child: const Text('Reset Changes'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : submitBlog,
                        child: isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('...'),
                                ],
                              )
                            : const Text('Update Blog'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
