import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogMapper {
  static BlogModel fromEntityToModel(BlogEntity blog) {
    return BlogModel(
      id: blog.id,
      title: blog.title,
      content: blog.content,
      authorId: blog.authorId,
      authorName: blog.authorName,
      coverImageUrl: blog.coverImageUrl,
      tags: blog.tags,
      createdAt: blog.createdAt,
      lastUpdatedAt: blog.lastUpdatedAt,
    );
  }

  static BlogEntity fromModelToEntity(BlogModel blog) {
    return BlogEntity(
      id: blog.id,
      title: blog.title,
      content: blog.content,
      authorId: blog.authorId,
      authorName: blog.authorName,
      coverImageUrl: blog.coverImageUrl,
      tags: blog.tags,
      createdAt: blog.createdAt,
      lastUpdatedAt: blog.lastUpdatedAt,
    );
  }

  static BlogModel fromJsonToModel(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return BlogModel(
      id: documentId,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: (json['createdAt'] is DateTime)
          ? json['createdAt']
          : (json['createdAt']?.toDate() ?? DateTime.now()),
      lastUpdatedAt: (json['lastUpdatedAt'] is DateTime)
          ? json['lastUpdatedAt']
          : (json['lastUpdatedAt']?.toDate() ?? DateTime.now()),
    );
  }

  static Map<String, dynamic> fromModelToJson(BlogModel blog) {
    return {
      'title': blog.title,
      'content': blog.content,
      'authorId': blog.authorId,
      'authorName': blog.authorName,
      'coverImageUrl': blog.coverImageUrl,
      'tags': blog.tags,
      'createdAt': Timestamp.fromDate(blog.createdAt),
      'lastUpdatedAt': Timestamp.fromDate(blog.lastUpdatedAt),
    };
  }

  static BlogModel fromFirestoreDocToModel(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return fromJsonToModel(data, doc.id);
  }
}
