import 'package:blog_app/features/blogs/presentation/bloc/engagement/engagement_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class LikeButton extends StatefulWidget {
  final String blogId;

  const LikeButton({super.key, required this.blogId});

  @override
  State<LikeButton> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<EngagementBloc, EngagementState>(
      builder: (context, state) {
        bool isLiked = false;

        if (state is EngagementLoaded) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            isLiked = state.engagement.isLikedBy(userId);
          }
        }

        // Use real-time data from stream
        final displayLiked = isLiked;

        return OutlinedButton.icon(
          onPressed: _isLoading ? null : () => _handleLikeTap(isLiked),
          icon: _isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      displayLiked
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary,
                    ),
                  ),
                )
              : Icon(
                  displayLiked
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_outlined,
                  size: 20,
                  color: displayLiked
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
          label: Text(displayLiked ? 'Liked' : 'Like'),
          style: OutlinedButton.styleFrom(
            foregroundColor: displayLiked
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            side: BorderSide(
              color: displayLiked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
        );
      },
    );
  }

  void _handleLikeTap(bool currentlyLiked) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _isLoading) return;

    // Simple loading state only
    setState(() {
      _isLoading = true;
    });

    try {
      // Database call - real-time stream will update UI
      context.read<EngagementBloc>().add(ToggleLike(widget.blogId, userId));

      // Reset loading after short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
