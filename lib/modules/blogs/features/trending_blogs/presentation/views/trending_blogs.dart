import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog_bloc.dart';
//TODO: update path accordingly ....
import 'package:blog_app/modules/blogs/features/blog_details/presentation/views/blog_preview_screen.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/view/blog_card.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

class TrendingBlogs extends StatefulWidget {
  const TrendingBlogs({super.key});

  @override
  State<TrendingBlogs> createState() => _TrendingBlogsState();
}

//TODO: filter the trending ones 1st
class _TrendingBlogsState extends State<TrendingBlogs> {
  void _openBlog(Blog blog) {
    //TODO: change the route after setup
    // context.goNamed(Routes.blog_details.name);
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: context.customTheme.contentPrimary,
              ),

              AppGaps.gapW12,

              Text(
                'Trending Blogs',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            dynamic blogs;
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
