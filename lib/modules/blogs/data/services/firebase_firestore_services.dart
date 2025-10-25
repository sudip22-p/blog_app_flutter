import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreBlogService {
  final CollectionReference blogsCollection = FirebaseFirestore.instance
      .collection('blogs');

  Future<void> addTask(
    String title,
    String content,
    String authorId,
    String authorName,
    String coverImageUrl,
    List<String> tags,
  ) async {
    await blogsCollection.add({
      "title": title,
      "content": content,
      "authorId": authorId,
      "authorName": authorName,
      "coverImageUrl": coverImageUrl,
      "tags": tags,
      "createdAt": DateTime.now(),
      "lastUpdatedAt": DateTime.now(),
    });
  }

  Future<void> deleteBlog(String blogId) async {
    await blogsCollection.doc(blogId).delete();
  }

  Future<void> updateBlog(
    String id,
    String title,
    String content,
    String authorId,
    String authorName,
    String coverImageUrl,
    List<String> tags,
  ) async {
    await blogsCollection.doc(id).update({
      "title": title,
      "content": content,
      "authorId": authorId,
      "authorName": authorName,
      "coverImageUrl": coverImageUrl,
      "tags": tags,
      "lastUpdatedAt": DateTime.now(),
    });
  }

  Stream<List<Blog>> getBlogsStream() {
    return FirebaseFirestore.instance
        .collection("blogs")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Blog.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
