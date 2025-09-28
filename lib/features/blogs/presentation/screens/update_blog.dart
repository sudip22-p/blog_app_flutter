import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/presentation/bloc/blog_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    currentBlog = widget.blogs.firstWhere((blog) => blog.id == widget.blogId);
    _titleController.text = currentBlog.title;
    _contentController.text = currentBlog.content;
    _tagsController.text = currentBlog.tags.join(",");
    _coverImageController.text = currentBlog.coverImageUrl ?? "";
  }

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _coverImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final String? currentUserName =
      FirebaseAuth.instance.currentUser?.displayName ?? "Unknown";

  void _submitBlog() {
    if (_formKey.currentState!.validate()) {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "N/A";
      final currentUserName =
          FirebaseAuth.instance.currentUser?.displayName ?? "Unknown";
      context.read<BlogBloc>().add(
        BlogUpdated(
          _titleController.text.trim(),
          _contentController.text.trim(),
          currentUserId,
          currentUserName,
          _coverImageController.text.trim(),
          _tagsController.text.trim().split(",").toList(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Blog Updated successfully!")),
      );
      Navigator.pop(context);
      _titleController.clear();
      _contentController.clear();
      _tagsController.clear();
      _coverImageController.clear();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _coverImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Blog")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a title" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "Content",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter content" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coverImageController,
                decoration: const InputDecoration(
                  labelText: "Cover Image URL (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: "Tags (comma separated)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitBlog,
                icon: const Icon(Icons.add),
                label: const Text("Update Blog"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
