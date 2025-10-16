
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/screens/add_blog.dart';
import 'package:blog_app/modules/blogs/presentation/screens/blog_preview_screen.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/blog_card.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsHome extends StatefulWidget {
  const BlogsHome({super.key});

  @override
  State<BlogsHome> createState() => _BlogsHomeState();
}

class _BlogsHomeState extends State<BlogsHome> {
  void _openBlog(Blog blog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.trending_up),
              const SizedBox(width: 8),
              Text(
                'Trending Blogs',
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Blog list
        BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            dynamic blogs;
            if (state is BlogInitial) {
              context.read<BlogBloc>().add(BlogsLoaded());
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogOperationFailure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is BlogOperationSuccess) {
              blogs = state.blogs;
              if (blogs.isEmpty) {
                // return const Center(child: Text('No blogs available.'));
                return EmptyState(
                  icon: Icons.article_outlined,
                  title: 'Welcome to Blog App !',
                  message:
                      'Start creating amazing content and share your thoughts with the world.',
                  buttonText: 'Create Your First Post',
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const AddBlog(),
                      ),
                    );
                  },
                );
              }
            } else if (state is BlogLoadSuccess) {
              blogs = state.blogs;
              if (blogs.isEmpty) {
                // return const Center(child: Text('No blogs available.'));
                return EmptyState(
                  icon: Icons.article_outlined,
                  title: 'Welcome to Blog App !',
                  message:
                      'Start creating amazing content and share your thoughts with the world.',
                  buttonText: 'Create Your First Post',
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const AddBlog(),
                      ),
                    );
                  },
                );
              }
            }
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return BlogCard(blog: blog, onTap: () => _openBlog(blog));
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
