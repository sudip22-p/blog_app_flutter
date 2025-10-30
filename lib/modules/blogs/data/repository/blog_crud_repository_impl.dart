import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BlogCrudRepository)
class BlogCrudRepositoryImpl implements BlogCrudRepository {
  final CollectionReference<Map<String, dynamic>> blogsCollection =
      FirebaseFirestore.instance.collection('blogs');

  @override
  Future<void> addBlog(BlogEntity blog) async {
    final model = BlogMapper.fromEntityToModel(blog);
    await blogsCollection.add(BlogMapper.fromModelToJson(model));
  }

  @override
  Future<void> updateBlog(BlogEntity blog) async {
    final model = BlogMapper.fromEntityToModel(blog);
    await blogsCollection
        .doc(blog.id)
        .update(BlogMapper.fromModelToJson(model));
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    await blogsCollection.doc(blogId).delete();
  }

  @override
  Stream<List<BlogEntity>> getBlogsStream() {
    return blogsCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BlogMapper.fromModelToEntity(
                  BlogMapper.fromFirestoreDocToModel(doc),
                ),
              )
              .toList(),
        );
  }
}
