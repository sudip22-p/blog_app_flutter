import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/di/injection.dart';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

part 'blog_engagement_event.dart';
part 'blog_engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  final GetBlogEngagementUseCase getBlogEngagementUseCase =
      getIt<GetBlogEngagementUseCase>();
  final GetBlogEngagementStreamUseCase getBlogEngagementStreamUseCase =
      getIt<GetBlogEngagementStreamUseCase>();
  final ToggleLikeUseCase toggleLikeUseCase = getIt<ToggleLikeUseCase>();
  final AddViewUseCase addViewUseCase = getIt<AddViewUseCase>();
  final AddCommentUseCase addCommentUseCase = getIt<AddCommentUseCase>();

  StreamSubscription<List<BlogEngagementEntity>>? _engagementSubscription;

  EngagementBloc() : super(EngagementInitial()) {
    on<LoadBlogEngagement>(_onLoadBlogEngagement);
    on<StartBlogEngagementStream>(_onStartBlogEngagementStream);
    on<ToggleLike>(_onToggleLike);
    on<AddView>(_onAddView);
    on<AddComment>(_onAddComment);
  }

  @override
  Future<void> close() {
    _engagementSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadBlogEngagement(
    LoadBlogEngagement event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());
    try {
      final engagements = await getBlogEngagementUseCase.execute(
        GetBlogEngagementUseCaseParams(blogId: event.blogId),
      );
      emit(EngagementLoaded(engagements));
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }

  Future<void> _onStartBlogEngagementStream(
    StartBlogEngagementStream event,
    Emitter<EngagementState> emit,
  ) async {
    emit(EngagementLoading());

    await _engagementSubscription?.cancel();

    try {
      final stream = await getBlogEngagementStreamUseCase.execute(NoParams());

      await emit.forEach<List<BlogEngagementEntity>>(
        stream,
        onData: (engagements) => EngagementLoaded(engagements),
        onError: (error, _) => EngagementError(error.toString()),
      );
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<EngagementState> emit,
  ) async {
    try {
      await toggleLikeUseCase.execute(
        ToggleLikeUseCaseParams(blogId: event.blogId, userId: event.userId),
      );
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }

  Future<void> _onAddView(AddView event, Emitter<EngagementState> emit) async {
    try {
      await addViewUseCase.execute(
        AddViewUseCaseParams(blogId: event.blogId, userId: event.userId),
      );
    } catch (_) {}
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<EngagementState> emit,
  ) async {
    try {
      await addCommentUseCase.execute(
        AddCommentUseCaseParams(blogId: event.blogId, comment: event.comment),
      );
    } catch (e) {
      emit(EngagementError(e.toString()));
    }
  }
}
