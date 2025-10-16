
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/features/favourite_blogs/data/models/favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFavoritesService {
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance
      .collection('favorites');
  final CollectionReference _blogsCollection = FirebaseFirestore.instance
      .collection('blogs');

  // Get user favorites
  Future<List<Favorite>> getUserFavorites(String userId) async {
    try {
      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Favorite.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      // print('Error fetching favorites: $e');
      return [];
    }
  }

  // Get user favorite blogs (with full blog data)
  Future<List<Blog>> getUserFavoriteBlogs(String userId) async {
    try {
      final favorites = await getUserFavorites(userId);
      final blogIds = favorites.map((f) => f.blogId).toList();

      if (blogIds.isEmpty) return [];

      final blogsQuery = await _blogsCollection
          .where(FieldPath.documentId, whereIn: blogIds)
          .get();

      return blogsQuery.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Blog.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      // print('Error fetching favorite blogs: $e');
      return [];
    }
  }

  // Add blog to favorites
  Future<void> addToFavorites(String userId, String blogId) async {
    await _favoritesCollection.add({
      'userId': userId,
      'blogId': blogId,
      'createdAt': DateTime.now(),
    });
  }

  // Remove blog from favorites
  Future<void> removeFromFavorites(String userId, String blogId) async {
    final querySnapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('blogId', isEqualTo: blogId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }

  // Check if blog is favorited by user
  Future<bool> isFavorited(String userId, String blogId) async {
    final querySnapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('blogId', isEqualTo: blogId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Simple toggle favorite
  Future<bool> toggleFavorite(String userId, String blogId) async {
    final isFav = await isFavorited(userId, blogId);

    if (isFav) {
      await removeFromFavorites(userId, blogId);
      return false;
    } else {
      await addToFavorites(userId, blogId);
      return true;
    }
  }
}
