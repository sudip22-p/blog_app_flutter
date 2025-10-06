import 'package:blog_app/features/blogs/data/models/blog.dart';
import 'package:blog_app/features/blogs/data/services/firebase_firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final firestoreService = FirestoreBlogService();

  BlogBloc() : super(BlogInitial()) {
    on<BlogsLoaded>(_onBlogsLoaded);
    on<NewBlogAdded>(_onNewBlogAdded);
    on<BlogUpdated>(_onBlogUpdated);
    on<BlogDeleted>(_onBlogDeleted);
  }
  @override
  void onChange(Change<BlogState> change) {
    super.onChange(change);
    print('auth bloc change - $change');
  }

  @override
  void onTransition(Transition<BlogEvent, BlogState> transition) {
    super.onTransition(transition);
    print("sud transition- $transition");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print("sud error- $error");
    print("sud stack trace- $stackTrace");
  }

  void _onBlogsLoaded(BlogsLoaded event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      await for (var blogs in firestoreService.getBlogsStream()) {
        emit(BlogLoadSuccess(blogs));
      }
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void _onNewBlogAdded(NewBlogAdded event, Emitter<BlogState> emit) async {
    try {
      await firestoreService.addTask(
        event.title,
        event.content,
        event.authorId,
        event.authorName,
        event.coverImageUrl,
        event.tags,
      );
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void _onBlogUpdated(BlogUpdated event, Emitter<BlogState> emit) async {
    try {
      await firestoreService.updateBlog(
        event.id,
        event.title,
        event.content,
        event.authorId,
        event.authorName,
        event.coverImageUrl,
        event.tags,
      );
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void _onBlogDeleted(BlogDeleted event, Emitter<BlogState> emit) async {
    try {
      await firestoreService.deleteBlog(event.id);
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }
}
