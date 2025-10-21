import 'package:blog_app/modules/blogs/features/blog_card/presentation/bloc/engagement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogEngagementInitializer extends StatefulWidget {
  final Widget child;
  const BlogEngagementInitializer({super.key, required this.child});

  @override
  State<BlogEngagementInitializer> createState() =>
      _BlogEngagementInitializerState();
}

class _BlogEngagementInitializerState extends State<BlogEngagementInitializer> {
  @override
  void initState() {
    super.initState();
    context.read<EngagementBloc>().add(StartBlogEngagementStream());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
