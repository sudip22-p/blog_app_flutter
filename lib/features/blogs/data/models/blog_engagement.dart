class BlogEngagement {
  final String blogId;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final Map<String, bool> likes; // userId -> true/false
  final Map<String, BlogComment> comments; // commentId -> comment
  final Map<String, DateTime> views; // userId -> timestamp

  BlogEngagement({
    required this.blogId,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.likes = const {},
    this.comments = const {},
    this.views = const {},
  });

  // Convert to Map for Firebase Realtime Database
  Map<String, dynamic> toMap() {
    return {
      'blogId': blogId,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'viewsCount': viewsCount,
      'likes': likes,
      'comments': comments.map((key, value) => MapEntry(key, value.toMap())),
      'views': views.map(
        (key, value) => MapEntry(key, value.millisecondsSinceEpoch),
      ),
    };
  }

  // Create from Map (Firebase Realtime Database)
  factory BlogEngagement.fromMap(Map<dynamic, dynamic> map, String blogId) {
    final likesMap = Map<String, bool>.from(map['likes'] ?? {});
    final commentsMap =
        (map['comments'] as Map<dynamic, dynamic>?)?.map(
          (key, value) => MapEntry(
            key.toString(),
            BlogComment.fromMap(
              Map<String, dynamic>.from(value),
              key.toString(),
            ),
          ),
        ) ??
        <String, BlogComment>{};
    final viewsMap =
        (map['views'] as Map<dynamic, dynamic>?)?.map(
          (key, value) => MapEntry(
            key.toString(),
            DateTime.fromMillisecondsSinceEpoch(value as int),
          ),
        ) ??
        <String, DateTime>{};

    return BlogEngagement(
      blogId: blogId,
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      viewsCount: map['viewsCount'] ?? 0,
      likes: likesMap,
      comments: commentsMap,
      views: viewsMap,
    );
  }

  // Helper methods
  bool isLikedBy(String userId) => likes[userId] == true;
  bool hasViewedBy(String userId) => views.containsKey(userId);
  List<BlogComment> get commentsList =>
      comments.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  BlogEngagement copyWith({
    int? likesCount,
    int? commentsCount,
    int? viewsCount,
    Map<String, bool>? likes,
    Map<String, BlogComment>? comments,
    Map<String, DateTime>? views,
  }) {
    return BlogEngagement(
      blogId: blogId,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      views: views ?? this.views,
    );
  }
}

class BlogComment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;

  BlogComment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BlogComment.fromMap(Map<String, dynamic> map, String commentId) {
    return BlogComment(
      id: commentId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      userAvatar: map['userAvatar'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  // Helper method to create copy
  BlogComment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? createdAt,
  }) {
    return BlogComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'BlogComment(id: $id, userId: $userId, userName: $userName, content: $content)';
  }
}
