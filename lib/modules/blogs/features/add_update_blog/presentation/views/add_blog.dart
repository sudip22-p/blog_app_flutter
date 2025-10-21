import 'dart:io';
import 'package:blog_app/common/services/cloudinary_services.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/modules/blogs/features/add_update_blog/presentation/widgets/form_widgets.dart';
import 'package:blog_app/modules/blogs/features/add_update_blog/presentation/widgets/image_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});
  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  File? selectedImage;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
        String imageUrl = '';
        // Uploading to Cloudinary if image selected
        if (selectedImage != null) {
          imageUrl = await cloudinaryService.uploadImage(selectedImage!);
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Blog published successfully!'),
              backgroundColor: context.customTheme.success,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error publishing blog: $e'),
              backgroundColor: context.customTheme.error,
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

  void clearForm() {
    _titleController.clear();
    _contentController.clear();
    _tagsController.clear();
    selectedImage = null;
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
      appBar: AppBar(
        title: const Text('Create New Blog'),
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
                        selectedImage = file;
                      },
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
                  color: context.customTheme.surface,
                  border: Border(
                    top: BorderSide(color: context.customTheme.outline, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : clearForm,
                        child: const Text('Clear All'),
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
                            : const Text('Publish Blog'),
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
