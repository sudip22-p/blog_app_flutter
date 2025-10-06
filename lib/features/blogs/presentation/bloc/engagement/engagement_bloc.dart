import 'dart:async';
import 'package:blog_app/features/blogs/data/services/realtime_database_engagement_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'engagement_event.dart';
import 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  final RealtimeDatabaseEngagementService _engagementService =
      RealtimeDatabaseEngagementService();
  final Map<String, StreamSubscription> _engagementSubscriptions = {};

  EngagementBloc() : super(EngagementInitial()) {
    on<LoadBlogEngagement>(_onLoadBlogEngagement);
    on<LoadMultipleBlogEngagements>(_onLoadMultipleBlogEngagements);
    on<ToggleLike>(_onToggleLike);
    on<AddView>(_onAddView);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<ToggleCommentLike>(_onToggleCommentLike);
    on<InitializeBlogEngagement>(_onInitializeBlogEngagement);
  }

  @override
  Future<void> close() {
    for (var subscription in _engagementSubscriptions.values) {
      subscription.cancel();
    }
    _engagementSubscriptions.clear();
    return super.close();
  }

  void _onLoadBlogEngagement(
    LoadBlogEngagement event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    try {
      // Cancel existing subscription for this blog
      await _engagementSubscriptions[event.blogId]?.cancel();

      // Get initial data without stream for now to avoid emit issues
      final engagement = await _engagementService.getBlogEngagement(
        event.blogId,
      );
      if (!isClosed) {
        emit(EngagementLoaded(engagement));
      }
    } catch (e) {
      if (!isClosed) {
        emit(EngagementOperationFailure(e.toString()));
      }
    }
  }

  void _onToggleLike(ToggleLike event, Emitter<EngagementState> emit) async {
    try {
      await _engagementService.toggleLike(event.blogId, event.userId);

      // Reload engagement data after toggle
      add(LoadBlogEngagement(event.blogId));
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  void _onAddView(AddView event, Emitter<EngagementState> emit) async {
    try {
      await _engagementService.addView(event.blogId, event.userId);

      // Don't automatically reload since views should be counted silently
      // The view count will be correct on next natural reload
      emit(EngagementOperationSuccess('View added'));
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  void _onAddComment(AddComment event, Emitter<EngagementState> emit) async {
    try {
      await _engagementService.addComment(event.blogId, event.comment);
      emit(EngagementOperationSuccess('Comment added successfully!'));

      // Reload engagement data to show new comment
      add(LoadBlogEngagement(event.blogId));
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  void _onDeleteComment(
    DeleteComment event,
    Emitter<EngagementState> emit,
  ) async {
    try {
      await _engagementService.deleteComment(event.blogId, event.commentId);
      emit(EngagementOperationSuccess('Comment deleted successfully!'));
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  void _onToggleCommentLike(
    ToggleCommentLike event,
    Emitter<EngagementState> emit,
  ) async {
    try {
      await _engagementService.toggleCommentLike(
        event.blogId,
        event.commentId,
        event.userId,
      );

      // Reload engagement data to show updated comment likes
      add(LoadBlogEngagement(event.blogId));
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  void _onInitializeBlogEngagement(
    InitializeBlogEngagement event,
    Emitter<EngagementState> emit,
  ) async {
    try {
      await _engagementService.initializeBlogEngagement(event.blogId);
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  void _onLoadMultipleBlogEngagements(
    LoadMultipleBlogEngagements event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    try {
      final engagements = await _engagementService.getMultipleBlogEngagements(
        event.blogIds,
      );
      emit(MultiBlogEngagementLoaded(engagements));
    } catch (e) {
      emit(EngagementOperationFailure(e.toString()));
    }
  }

  // Helper method to get current user ID
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
}
