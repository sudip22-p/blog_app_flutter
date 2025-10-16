import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String userId;
  final String blogId;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.blogId,
    required this.createdAt,
  });

  // Convert Favorite to Map (Firestore friendly)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'blogId': blogId,
      'createdAt': createdAt,
    };
  }

  // Create Favorite from Map (Firestore doc snapshot)
  factory Favorite.fromMap(Map<String, dynamic> map, String documentId) {
    return Favorite(
      id: documentId,
      userId: map['userId'] ?? '',
      blogId: map['blogId'] ?? '',
      createdAt: _convertToDateTime(map['createdAt']),
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

  @override
  String toString() {
    return 'Favorite(id: $id, userId: $userId, blogId: $blogId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite &&
        other.id == id &&
        other.userId == userId &&
        other.blogId == blogId;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ blogId.hashCode;
}