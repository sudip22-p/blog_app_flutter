import 'package:blog_app/modules/blogs/blogs.dart';

class BlogCommentMapper {
  static BlogCommentModel fromEntityToModel(BlogCommentEntity entity) {
    return BlogCommentModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userAvatar: entity.userAvatar,
      content: entity.content,
      createdAt: entity.createdAt,
    );
  }

  static BlogCommentEntity fromModelToEntity(BlogCommentModel model) {
    return BlogCommentEntity(
      id: model.id,
      userId: model.userId,
      userName: model.userName,
      userAvatar: model.userAvatar,
      content: model.content,
      createdAt: model.createdAt,
    );
  }

  static Map<String, dynamic> fromModelToJson(BlogCommentModel model) {
    return {
      // Do not include 'id' - in Firebase, ID is often the map key.
      'userId': model.userId,
      'userName': model.userName,
      'userAvatar': model.userAvatar,
      'content': model.content,
      // Use milliseconds for better Firebase interop, or ISO if you prefer strings
      'createdAt': model.createdAt.toIso8601String(),
    };
  }

  /// When reading from Firebase, you get {commentId: { ...data... }}
  static BlogCommentModel fromJsonToModel(
    String id,
    Map<String, dynamic> json,
  ) {
    return BlogCommentModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userAvatar: json['userAvatar'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: _parseCreatedAt(json['createdAt']),
    );
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is int) {
      // Assume milliseconds since epoch
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      // Try parsing ISO
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      // Fallback
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
