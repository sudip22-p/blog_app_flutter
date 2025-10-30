part of 'blog_crud_bloc.dart';

sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogLoadSuccess extends BlogState {
  final List<BlogEntity> blogs;
  const BlogLoadSuccess(this.blogs);
  @override
  List<Object> get props => [blogs];
}

final class BlogOperationFailure extends BlogState {
  final String message;
  const BlogOperationFailure(this.message);
  @override
  List<Object> get props => [message];
}

final class BlogOperationSuccess extends BlogState {
  final List<BlogEntity> blogs;
  const BlogOperationSuccess(this.blogs);
  @override
  List<Object> get props => [blogs];
}
