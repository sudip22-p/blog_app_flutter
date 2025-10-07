import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseEngagementService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get current engagement data (one-time fetch)
  Future<BlogEngagement> getBlogEngagement(String blogId) async {
    final snapshot = await _database
        .child('blog_engagement')
        .child(blogId)
        .get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return BlogEngagement.fromMap(data, blogId);
    } else {
      // Return empty engagement if doesn't exist
      return BlogEngagement(blogId: blogId);
    }
  }

  // Get engagement stream (real-time updates)
  Stream<BlogEngagement> getBlogEngagementStream(String blogId) {
    return _database.child('blog_engagement').child(blogId).onValue.map((
      event,
    ) {
      if (event.snapshot.value == null) {
        return BlogEngagement(blogId: blogId);
      }

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return BlogEngagement.fromMap(data, blogId);
    });
  }

  // Like/Unlike a blog
  Future<void> toggleLike(String blogId, String userId) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final snapshot = await blogRef.get();

    Map<String, dynamic> data = {};
    if (snapshot.exists) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }

    final likes = Map<String, bool>.from(data['likes'] ?? {});
    final currentlyLiked = likes[userId] == true;

    if (currentlyLiked) {
      likes.remove(userId);
    } else {
      likes[userId] = true;
    }

    await blogRef.update({'likes': likes, 'likesCount': likes.length});
  }

  // Add a view
  Future<void> addView(String blogId, String userId) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final snapshot = await blogRef.get();

    Map<String, dynamic> data = {};
    if (snapshot.exists) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }

    final views = Map<String, dynamic>.from(data['views'] ?? {});

    // Only count unique views (don't increment if user already viewed)
    if (!views.containsKey(userId)) {
      views[userId] = DateTime.now().millisecondsSinceEpoch;

      await blogRef.update({'views': views, 'viewsCount': views.length});
    }
  }

  // Add a comment
  Future<void> addComment(String blogId, BlogComment comment) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final commentsRef = blogRef.child('comments');

    // Add the comment
    await commentsRef.child(comment.id).set(comment.toMap());

    // Update comment count
    final snapshot = await blogRef.get();
    Map<String, dynamic> data = {};
    if (snapshot.exists) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }

    final comments = Map<String, dynamic>.from(data['comments'] ?? {});
    await blogRef.update({'commentsCount': comments.length});
  }

  // Delete a comment
  Future<void> deleteComment(String blogId, String commentId) async {
    final blogRef = _database.child('blog_engagement').child(blogId);

    // Remove the comment
    await blogRef.child('comments').child(commentId).remove();

    // Update comment count
    final snapshot = await blogRef.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final comments = Map<String, dynamic>.from(data['comments'] ?? {});

      await blogRef.update({'commentsCount': comments.length});
    }
  }

  // Toggle comment like
  Future<void> toggleCommentLike(
    String blogId,
    String commentId,
    String userId,
  ) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final commentRef = blogRef.child('comments').child(commentId);

    // Get current comment data
    final commentSnapshot = await commentRef.get();
    if (!commentSnapshot.exists) {
      throw Exception('Comment not found');
    }

    final commentData = Map<String, dynamic>.from(commentSnapshot.value as Map);
    final likes = Map<String, bool>.from(commentData['likes'] ?? {});
    final currentlyLiked = likes[userId] == true;

    // Toggle like status
    if (currentlyLiked) {
      likes.remove(userId);
    } else {
      likes[userId] = true;
    }
    // Update comment with new likes
    await commentRef.update({'likes': likes, 'likesCount': likes.length});
  }

  // Get engagement metrics for multiple blogs
  Future<Map<String, BlogEngagement>> getMultipleBlogEngagements(
    List<String> blogIds,
  ) async {
    Map<String, BlogEngagement> engagements = {};

    for (String blogId in blogIds) {
      final snapshot = await _database
          .child('blog_engagement')
          .child(blogId)
          .get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        engagements[blogId] = BlogEngagement.fromMap(data, blogId);
      } else {
        engagements[blogId] = BlogEngagement(blogId: blogId);
      }
    }

    return engagements;
  }

  // Initialize engagement data for a new blog
  Future<void> initializeBlogEngagement(String blogId) async {
    final blogRef = _database.child('blog_engagement').child(blogId);

    await blogRef.set({
      'blogId': blogId,
      'likesCount': 0,
      'commentsCount': 0,
      'viewsCount': 0,
      'likes': {},
      'comments': {},
      'views': {},
    });
  }

  // Delete all engagement data for a blog
  Future<void> deleteBlogEngagement(String blogId) async {
    await _database.child('blog_engagement').child(blogId).remove();
  }
}
