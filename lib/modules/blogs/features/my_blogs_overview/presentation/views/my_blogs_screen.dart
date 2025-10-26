import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyBlogsScreen extends StatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  State<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends State<MyBlogsScreen> {
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void deleteBlog(Blog blog) async {
    bool deleteConfirmation = await DialogUtils.showConfirmationDialog(
      context,
      title: "Delete Blog Confirmation",
      message: 'Are you sure you want to delete "${blog.title}"?',

      confirmText: "Delete",
      cancelText: "Cancel",
    );
    if (deleteConfirmation && mounted) {
      context.read<BlogBloc>().add(BlogDeleted(blog.id));
      CustomSnackbar.showToastMessage(
        type: ToastType.success,
        message: "Blog Deleted Successfully!",
      );
    }
  }

  void editBlog(Blog blog, List<Blog> allBlogs) {
    context.pushNamed(Routes.editBlog.name, extra: blog);
  }

  void previewBlog(Blog blog) {
    context.pushNamed(Routes.blogDetails.name, extra: blog);
  }

  void addBlog() {
    context.pushNamed(Routes.addBlog.name);
  }

  List<Blog> getMyBlogs(List<Blog> allBlogs) {
    if (currentUserId == null) return [];
    return allBlogs.where((blog) => blog.authorId == currentUserId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme.surface,
      appBar: CustomAppBarWidget(
        title: Text(
          "My Blogs",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        backgroundColor: context.customTheme.background,
        actions: [
          IconButton(
            onPressed: addBlog,
            icon: Icon(
              Icons.add_box_outlined,
              size: AppSpacing.xlg,
              color: context.customTheme.primary,
            ),
            tooltip: 'Create New Blog',
          ),
        ],
      ),

      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogInitial) {
            context.read<BlogBloc>().add(BlogsLoaded());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogOperationFailure) {
            return Center(
              child: EmptyState(
                icon: Icons.error,
                title: 'Error Loading Blogs',
                message: state.errorMessage,
                buttonText: 'Retry',
                onButtonPressed: () => {
                  context.read<BlogBloc>().add(BlogsLoaded()),
                },
              ),
            );
          }

          // Handle success states
          List<Blog> allBlogs = [];
          if (state is BlogLoadSuccess) {
            allBlogs = state.blogs;
          } else if (state is BlogOperationSuccess) {
            allBlogs = state.blogs;
          }

          // Filter blogs for current user
          final myBlogsList = getMyBlogs(allBlogs);

          // Check if user is not logged in
          if (currentUserId == null) {
            Center(
              child: EmptyState(
                icon: Icons.error,
                title: 'User Not Authenticated',
                message: 'Please log in to view your blogs',
                buttonText: 'Login',
                onButtonPressed: () => {
                  context.goNamed(Routes.authWrapper.name),
                },
              ),
            );
          }

          return myBlogsList.isEmpty
              ? EmptyState(
                  icon: Icons.edit_note_outlined,
                  title: 'Start Your Writing Journey!',
                  message:
                      'You haven\'t created any blogs yet. Share your ideas and stories with the world.',
                  buttonText: 'Write Your First Blog',
                  onButtonPressed: () {
                    context.pushNamed(Routes.addBlog.name);
                  },
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.xlg,
                        bottom: AppSpacing.sm,
                        top: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_stories,
                            color: context.customTheme.contentPrimary,
                          ),

                          AppGaps.gapW12,

                          Text(
                            '${myBlogsList.length} blog${myBlogsList.length == 1 ? '' : 's'} published',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Blog list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        itemCount: myBlogsList.length,
                        itemBuilder: (context, index) {
                          final blog = myBlogsList[index];
                          return BlogCard(
                            blog: blog,
                            showActions: true,
                            onEdit: () => editBlog(blog, allBlogs),
                            onDelete: () => deleteBlog(blog),
                            onTap: () => previewBlog(blog),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
