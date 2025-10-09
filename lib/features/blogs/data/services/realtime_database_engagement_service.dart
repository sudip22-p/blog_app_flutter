import 'package:blog_app/features/blogs/data/models/blog_engagement.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseEngagementService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get real-time engagement stream (preferred for real-time updates)
  Stream<BlogEngagement> getBlogEngagementStream(String blogId) {
    return _database.child('blog_engagement').child(blogId).onValue.map((
      event,
    ) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return BlogEngagement.fromMap(data, blogId);
      } else {
        return BlogEngagement(blogId: blogId);
      }
    });
  }

  // Get current engagement data (fallback method)
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

  // Toggle like for a blog
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

    // Always recalculate the count from actual data to ensure accuracy
    final accurateCount = likes.length;

    await blogRef.update({'likes': likes, 'likesCount': accurateCount});
  }

  // Add view count
  Future<void> addView(String blogId, String userId) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final snapshot = await blogRef.get();

    Map<String, dynamic> data = {};
    if (snapshot.exists) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }

    final views = Map<String, dynamic>.from(data['views'] ?? {});

    // Only count unique views
    if (!views.containsKey(userId)) {
      views[userId] = DateTime.now().millisecondsSinceEpoch;
      final accurateCount = views.length;

      await blogRef.update({'views': views, 'viewsCount': accurateCount});
    }
  }

  // Add comment (simplified - no likes on comments)
  Future<void> addComment(String blogId, BlogComment comment) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final commentsRef = blogRef.child('comments');

    // Add the comment (no likes field needed)
    await commentsRef.child(comment.id).set(comment.toMap());

    // Get updated comments and recalculate count
    final snapshot = await blogRef.get();
    Map<String, dynamic> data = {};
    if (snapshot.exists) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }

    final comments = Map<String, dynamic>.from(data['comments'] ?? {});
    final accurateCount = comments.length;

    await blogRef.update({'commentsCount': accurateCount});
  }
}
