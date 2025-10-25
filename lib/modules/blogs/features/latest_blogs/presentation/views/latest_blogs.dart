import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LatestBlogs extends StatefulWidget {
  const LatestBlogs({super.key});

  @override
  State<LatestBlogs> createState() => _LatestBlogsState();
}

class _LatestBlogsState extends State<LatestBlogs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: context.customTheme.contentPrimary,
              ),

              AppGaps.gapW12,

              Text(
                'Latest Blogs',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            List<Blog> blogs = [];
            if (state is BlogInitial) {
              context.read<BlogBloc>().add(BlogsLoaded());
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BlogOperationFailure) {
              CustomSnackbar.showToastMessage(
                type: ToastType.error,
                message: state.errorMessage,
              );
              return EmptyState(
                icon: Icons.error,
                title: 'Failed to Fetch the Blogs!',
                message: 'Reload the Blogs Again.',
                buttonText: 'Reload',
                onButtonPressed: () {
                  context.goNamed(Routes.dashboard.name);
                },
              );
            } else if (state is BlogOperationSuccess) {
              blogs = state.blogs;
              blogs = blogs.take(12).toList();
              if (blogs.isEmpty) {
                return EmptyState(
                  icon: Icons.article_outlined,
                  title: 'No Blogs Available !',
                  message: 'An Unknown Error Occurred While Loading Blogs.',
                  buttonText: 'Reload',
                  onButtonPressed: () {
                    context.pushNamed(Routes.dashboard.name);
                  },
                );
              }
            } else if (state is BlogLoadSuccess) {
              blogs = state.blogs;
              blogs = blogs.take(12).toList();
              if (blogs.isEmpty) {
                return EmptyState(
                  icon: Icons.article_outlined,
                  title: 'No Blogs Available !',
                  message:
                      'Start creating amazing content and share your thoughts with the world.',
                  buttonText: 'Create Blog',
                  onButtonPressed: () {
                    context.pushNamed(Routes.addBlog.name);
                  },
                );
              }
            }
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return BlogCard(blog: blog);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
