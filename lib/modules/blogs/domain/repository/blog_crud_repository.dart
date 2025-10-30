import 'package:blog_app/modules/blogs/blogs.dart';

abstract class BlogCrudRepository {
  Future<void> addBlog(BlogEntity blog);

  Future<void> updateBlog(BlogEntity blog);

  Future<void> deleteBlog(String blogId);

  Stream<List<BlogEntity>> getBlogsStream();
}
