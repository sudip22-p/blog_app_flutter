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

  static DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is DateTime) {
      return value;
    } else {
      return DateTime.now();
    }
  }
}
