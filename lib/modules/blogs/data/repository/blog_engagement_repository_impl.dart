import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BlogEngagementRepository)
class BlogEngagementRepositoryImpl implements BlogEngagementRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Stream<List<BlogEngagementEntity>> getBlogEngagementStream() {
    return _database.child('blog_engagement').onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.entries.map((entry) {
          final blogData = Map<String, dynamic>.from(entry.value as Map);
          BlogEngagementModel engagement = BlogEngagementMapper.fromJsonToModel(
            entry.key,
            blogData,
          );
          return BlogEngagementMapper.fromModelToEntity(engagement);
        }).toList();
      } else {
        return <BlogEngagementEntity>[];
      }
    });
  }

  @override
  Future<List<BlogEngagementEntity>> getBlogEngagement(String blogId) async {
    final snapshot = await _database.child('blog_engagement').get();

    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((entry) {
        final blogData = Map<String, dynamic>.from(entry.value as Map);
        BlogEngagementModel engagement = BlogEngagementMapper.fromJsonToModel(
          entry.key,
          blogData,
        );
        return BlogEngagementMapper.fromModelToEntity(engagement);
      }).toList();
    } else {
      return <BlogEngagementEntity>[];
    }
  }

  @override
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
    final accurateCount = likes.length;
    await blogRef.update({'likes': likes, 'likesCount': accurateCount});
  }

  @override
  Future<void> addView(String blogId, String userId) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final snapshot = await blogRef.get();
    Map<String, dynamic> data = {};
    if (snapshot.exists) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }
    final views = Map<String, dynamic>.from(data['views'] ?? {});
    if (!views.containsKey(userId)) {
      views[userId] = DateTime.now().toIso8601String();
      final accurateCount = views.length;
      await blogRef.update({'views': views, 'viewsCount': accurateCount});
    }
  }

  @override
  Future<void> addComment(String blogId, BlogCommentEntity comment) async {
    final blogRef = _database.child('blog_engagement').child(blogId);
    final commentsRef = blogRef.child('comments');
    await commentsRef
        .child(comment.id)
        .set(
          BlogCommentMapper.fromModelToJson(
            BlogCommentMapper.fromEntityToModel(comment),
          ),
        );
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
