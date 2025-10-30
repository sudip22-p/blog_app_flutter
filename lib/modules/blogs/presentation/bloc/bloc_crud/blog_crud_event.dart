part of 'blog_crud_bloc.dart';

sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class BlogsLoaded extends BlogEvent {}

class NewBlogAdded extends BlogEvent {
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String coverImageUrl;
  final List<String> tags;
  const NewBlogAdded(
    this.title,
    this.content,
    this.authorId,
    this.authorName,
    this.coverImageUrl,
    this.tags,
  );
  @override
  List<Object> get props => [
    title,
    content,
    authorId,
    authorName,
    coverImageUrl,
    tags,
  ];
}

class BlogUpdated extends BlogEvent {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String coverImageUrl;
  final List<String> tags;
  final DateTime createdAt;
  const BlogUpdated(
    this.id,
    this.title,
    this.content,
    this.authorId,
    this.authorName,
    this.coverImageUrl,
    this.tags,
    this.createdAt,
  );
  @override
  List<Object> get props => [
    title,
    content,
    authorId,
    authorName,
    coverImageUrl,
    tags,
  ];
}

class BlogDeleted extends BlogEvent {
  final String id;
  const BlogDeleted(this.id);
  @override
  List<Object> get props => [id];
}
