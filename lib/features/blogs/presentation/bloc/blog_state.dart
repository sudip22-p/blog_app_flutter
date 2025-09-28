part of 'blog_bloc.dart';

sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogLoadSuccess extends BlogState {
  final List<Blog> blogs;

  const BlogLoadSuccess(this.blogs);

  @override
  List<Object> get props => [blogs];
}

final class BlogOperationFailure extends BlogState {
  final String errorMessage;

  const BlogOperationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class BlogOperationSuccess extends BlogState {
  final List<Blog> blogs;

  const BlogOperationSuccess(this.blogs);

  @override
  List<Object> get props => [blogs];
}
