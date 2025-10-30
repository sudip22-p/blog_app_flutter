import 'dart:async';
import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:blog_app/common/usecases/usecases.dart';
import 'package:blog_app/core/di/injection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_crud_event.dart';
part 'blog_crud_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetBlogsStreamUseCase getBlogsStreamUseCase =
      getIt<GetBlogsStreamUseCase>();
  final AddBlogUseCase addBlogUseCase = getIt<AddBlogUseCase>();
  final UpdateBlogUseCase updateBlogUseCase = getIt<UpdateBlogUseCase>();
  final DeleteBlogUseCase deleteBlogUseCase = getIt<DeleteBlogUseCase>();

  BlogBloc() : super(BlogInitial()) {
    on<BlogsLoaded>(onBlogsLoaded);
    on<NewBlogAdded>(onNewBlogAdded);
    on<BlogUpdated>(onBlogUpdated);
    on<BlogDeleted>(onBlogDeleted);
  }
  StreamSubscription<List<BlogEntity>>? _blogsSubscription;

  @override
  Future<void> close() {
    _blogsSubscription?.cancel();
    return super.close();
  }

  void onBlogsLoaded(BlogsLoaded event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      await _blogsSubscription?.cancel();
      final stream = await getBlogsStreamUseCase.execute(NoParams());
      await emit.forEach<List<BlogEntity>>(
        stream,
        onData: (blogs) => BlogLoadSuccess(blogs),
        onError: (error, _) => BlogOperationFailure(error.toString()),
      );
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void onNewBlogAdded(NewBlogAdded event, Emitter<BlogState> emit) async {
    try {
      final blog = BlogEntity(
        id: null,
        title: event.title,
        content: event.content,
        authorId: event.authorId,
        authorName: event.authorName,
        coverImageUrl: event.coverImageUrl,
        tags: event.tags,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      );
      await addBlogUseCase.execute(AddBlogUseCaseParams(blog: blog));
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void onBlogUpdated(BlogUpdated event, Emitter<BlogState> emit) async {
    try {
      final blog = BlogEntity(
        id: event.id,
        title: event.title,
        content: event.content,
        authorId: event.authorId,
        authorName: event.authorName,
        coverImageUrl: event.coverImageUrl,
        tags: event.tags,
        createdAt: event.createdAt,
        lastUpdatedAt: DateTime.now(),
      );
      await updateBlogUseCase.execute(UpdateBlogUseCaseParams(blog: blog));
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void onBlogDeleted(BlogDeleted event, Emitter<BlogState> emit) async {
    try {
      await deleteBlogUseCase.execute(
        DeleteBlogUseCaseParams(blogId: event.id),
      );
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }
}
