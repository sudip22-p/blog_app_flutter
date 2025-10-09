import 'package:blog_app/features/blogs/data/services/realtime_database_engagement_service.dart';
import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

part 'engagement_event.dart';
part 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  final RealtimeDatabaseEngagementService _engagementService =
      RealtimeDatabaseEngagementService();

  StreamSubscription<BlogEngagement>? _engagementSubscription;

  EngagementBloc() : super(EngagementInitial()) {
    on<LoadBlogEngagement>(_onLoadBlogEngagement);
    on<StartBlogEngagementStream>(_onStartBlogEngagementStream);
    on<EngagementStreamUpdate>(_onEngagementStreamUpdate);
    on<ToggleLike>(_onToggleLike);
    on<AddView>(_onAddView);
    on<AddComment>(_onAddComment);
  }

  @override
  Future<void> close() {
    _engagementSubscription?.cancel();
    return super.close();
  }

  void _onLoadBlogEngagement(
    LoadBlogEngagement event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    try {
      final engagement = await _engagementService.getBlogEngagement(
        event.blogId,
      );
      if (!isClosed) {
        emit(EngagementLoaded(engagement));
      }
    } catch (e) {
      if (!isClosed) {
        emit(EngagementError(e.toString()));
      }
    }
  }

  void _onStartBlogEngagementStream(
    StartBlogEngagementStream event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    // Cancel any existing subscription
    await _engagementSubscription?.cancel();

    // Start new stream subscription
    _engagementSubscription = _engagementService
        .getBlogEngagementStream(event.blogId)
        .listen(
          (engagement) {
            if (!isClosed) {
              add(EngagementStreamUpdate(engagement));
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(EngagementError(error.toString()));
            }
          },
        );
  }

  void _onEngagementStreamUpdate(
    EngagementStreamUpdate event,
    Emitter<EngagementState> emit,
  ) {
    if (!isClosed) {
      emit(EngagementLoaded(event.engagement));
    }
  }

  void _onToggleLike(ToggleLike event, Emitter<EngagementState> emit) async {
    try {
      // Simple database operation - real-time stream will handle updates
      await _engagementService.toggleLike(event.blogId, event.userId);
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }

  void _onAddView(AddView event, Emitter<EngagementState> emit) async {
    try {
      await _engagementService.addView(event.blogId, event.userId);
      // Views are added silently - no state change needed
    } catch (e) {
      // Silently fail for views - not critical
    }
  }

  void _onAddComment(AddComment event, Emitter<EngagementState> emit) async {
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
