import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String? coverImageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final BlogEngagement? engagement;
  final bool? isFavorited;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.coverImageUrl,
    required this.tags,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.engagement,
    this.isFavorited,
  });

  // Convert Blog to Map (Firestore friendly)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'coverImageUrl': coverImageUrl,
      'tags': tags,
      'createdAt': createdAt,
      'lastUpdatedAt': lastUpdatedAt,
    };
  }

  // Create Blog from Map (Firestore doc snapshot)
  factory Blog.fromMap(Map<String, dynamic> map, String documentId) {
    return Blog(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      coverImageUrl: map['coverImageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: _convertToDateTime(map['createdAt']),
      lastUpdatedAt: _convertToDateTime(map['lastUpdatedAt']),
    );
  }

  // Copy with method for updating engagement and favorite status
  Blog copyWith({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? authorName,
    String? coverImageUrl,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    BlogEngagement? engagement,
    bool? isFavorited,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      engagement: engagement ?? this.engagement,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  static DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is DateTime) {
      return value;
    } else {
      return DateTime.now();
    }
  }

  // Helper methods for easy access to engagement metrics
  int get likesCount => engagement?.likesCount ?? 0;
  int get commentsCount => engagement?.commentsCount ?? 0;
  int get viewsCount => engagement?.viewsCount ?? 0;
  
  bool isLikedBy(String userId) => engagement?.isLikedBy(userId) ?? false;
  bool hasViewedBy(String userId) => engagement?.hasViewedBy(userId) ?? false;
  List<BlogComment> get comments => engagement?.commentsList ?? [];

  @override
  String toString() {
    return 'Blog(id: $id, title: $title, likesCount: $likesCount, isFavorited: $isFavorited)';
  }
}
