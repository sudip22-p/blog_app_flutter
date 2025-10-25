import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

part 'engagement_event.dart';
part 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  final RealtimeDatabaseEngagementService _engagementService =
      RealtimeDatabaseEngagementService();

  StreamSubscription<List<BlogEngagement>>? _engagementSubscription;

  EngagementBloc() : super(EngagementInitial()) {
    on<LoadBlogEngagement>(onLoadBlogEngagement);
    on<StartBlogEngagementStream>(onStartBlogEngagementStream);
    on<EngagementStreamUpdate>(onEngagementStreamUpdate);
    on<ToggleLike>(onToggleLike);
    on<AddView>(onAddView);
    on<AddComment>(onAddComment);
  }

  @override
  Future<void> close() {
    _engagementSubscription?.cancel();
    return super.close();
  }

  void onLoadBlogEngagement(
    LoadBlogEngagement event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    try {
      final engagements = await _engagementService.getBlogEngagement(
        event.blogId,
      );
      if (!isClosed) {
        emit(EngagementLoaded(engagements));
      }
    } catch (e) {
      if (!isClosed) {
        emit(EngagementError(e.toString()));
      }
    }
  }

  void onStartBlogEngagementStream(
    StartBlogEngagementStream event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    // Cancel any existing subscription
    await _engagementSubscription?.cancel();

    // Start new stream subscription
    _engagementSubscription = _engagementService
        .getBlogEngagementStream()
        .listen(
          (engagements) {
            if (!isClosed) {
              add(EngagementStreamUpdate(engagements));
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(EngagementError(error.toString()));
            }
          },
        );
  }

  void onEngagementStreamUpdate(
    EngagementStreamUpdate event,
    Emitter<EngagementState> emit,
  ) {
    if (!isClosed) {
      emit(EngagementLoaded(event.engagements));
    }
  }

  void onToggleLike(ToggleLike event, Emitter<EngagementState> emit) async {
    try {
      // Simple database operation - real-time stream will handle updates
      await _engagementService.toggleLike(event.blogId, event.userId);
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }

  void onAddView(AddView event, Emitter<EngagementState> emit) async {
    try {
      await _engagementService.addView(event.blogId, event.userId);
      // Views are added silently - no state change needed
    } catch (e) {
      // Silently fail for views - not critical
    }
  }

  void onAddComment(AddComment event, Emitter<EngagementState> emit) async {
    try {
      // Simple database operation - real-time stream will handle updates
      await _engagementService.addComment(event.blogId, event.comment);
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }

  // Helper method to get current user ID
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
}
