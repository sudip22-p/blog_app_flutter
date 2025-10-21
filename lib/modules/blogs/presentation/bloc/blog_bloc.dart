import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/data/services/firebase_firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final firestoreService = FirestoreBlogService();

  BlogBloc() : super(BlogInitial()) {
    on<BlogsLoaded>(onBlogsLoaded);
    on<NewBlogAdded>(onNewBlogAdded);
    on<BlogUpdated>(onBlogUpdated);
    on<BlogDeleted>(onBlogDeleted);
  }

  void onBlogsLoaded(BlogsLoaded event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      await for (var blogs in firestoreService.getBlogsStream()) {
        emit(BlogLoadSuccess(blogs));
      }
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }

  void onNewBlogAdded(NewBlogAdded event, Emitter<BlogState> emit) async {
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

  void onBlogUpdated(BlogUpdated event, Emitter<BlogState> emit) async {
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

  void onBlogDeleted(BlogDeleted event, Emitter<BlogState> emit) async {
    try {
      await firestoreService.deleteBlog(event.id);
    } catch (e) {
      emit(BlogOperationFailure(e.toString()));
    }
  }
}
