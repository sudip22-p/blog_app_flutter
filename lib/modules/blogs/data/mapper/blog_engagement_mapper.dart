import 'package:blog_app/modules/blogs/blogs.dart';

class BlogEngagementMapper {
  static BlogEngagementModel fromEntityToModel(
    BlogEngagementEntity engagement,
  ) {
    return BlogEngagementModel(
      blogId: engagement.blogId,
      likesCount: engagement.likesCount,
      commentsCount: engagement.commentsCount,
      viewsCount: engagement.viewsCount,
      likes: engagement.likes,
      comments: engagement.comments
          .map(
            (commentEntity) =>
                BlogCommentMapper.fromEntityToModel(commentEntity),
          )
          .toList(),
      views: engagement.views,
    );
  }

  static BlogEngagementEntity fromModelToEntity(
    BlogEngagementModel engagement,
  ) {
    return BlogEngagementEntity(
      blogId: engagement.blogId,
      likesCount: engagement.likesCount,
      commentsCount: engagement.commentsCount,
      viewsCount: engagement.viewsCount,
      likes: engagement.likes,
      comments: engagement.comments
          .map(
            (commentModel) => BlogCommentMapper.fromModelToEntity(commentModel),
          )
          .toList(),
      views: engagement.views,
    );
  }

  static BlogEngagementModel fromJsonToModel(
    String blogId,
    Map<dynamic, dynamic> json,
  ) {
    // Likes: Map<String, bool>
    final likes = <String, bool>{};
    if (json['likes'] != null) {
      Map<String, dynamic>.from(json['likes'] as Map).forEach((key, value) {
        likes[key] = value == true;
      });
    }

    // Views: Map<String, DateTime>
    final views = <String, DateTime>{};
    if (json['views'] != null) {
      Map<String, dynamic>.from(json['views'] as Map).forEach((key, value) {
        DateTime? dateTime;
        if (value is int) {
          dateTime = DateTime.fromMillisecondsSinceEpoch(value);
        } else if (value is String) {
          dateTime = DateTime.tryParse(value);
        }
        if (dateTime != null) {
          views[key] = dateTime;
        }
      });
    }

    // Comments
    final commentsList = <BlogCommentModel>[];
    if (json['comments'] != null) {
      Map<dynamic, dynamic>.from(json['comments'] as Map).forEach((key, value) {
        if (value is Map) {
          commentsList.add(
            BlogCommentMapper.fromJsonToModel(
              key.toString(),
              Map<String, dynamic>.from(value),
            ),
          );
        }
      });
    }

    return BlogEngagementModel(
      blogId: blogId,
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? commentsList.length,
      viewsCount: json['viewsCount'] ?? views.length,
      likes: likes,
      comments: commentsList,
      views: views,
    );
  }

  static Map<String, dynamic> fromModelToJson(BlogEngagementModel model) {
    return {
      'blogId': model.blogId,
      'likesCount': model.likesCount,
      'commentsCount': model.commentsCount,
      'viewsCount': model.viewsCount,
      'likes': model.likes,
      'comments': model.comments
          .map(
            (commentModel) => BlogCommentMapper.fromModelToJson(commentModel),
          )
          .toList(),
      'views': model.views.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
    };
  }
}
