import 'package:blog_app/features/blogs/data/models/favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFavoritesService {
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance
      .collection('favorites');

  // Get user favorites (one-time fetch)
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
      // If index doesn't exist, return empty list
      print('Error fetching favorites: $e');
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
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Check if blog is favorited by user
  Future<bool> isFavorited(String userId, String blogId) async {
    final querySnapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('blogId', isEqualTo: blogId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Get user's favorite blogs stream
  Stream<List<Favorite>> getUserFavoritesStream(String userId) {
    return _favoritesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Favorite.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  // Get all favorites for a blog (to count favorites)
  Stream<List<Favorite>> getBlogFavoritesStream(String blogId) {
    return _favoritesCollection
        .where('blogId', isEqualTo: blogId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Favorite.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  // Get favorite count for a blog
  Future<int> getFavoriteCount(String blogId) async {
    final querySnapshot = await _favoritesCollection
        .where('blogId', isEqualTo: blogId)
        .get();

    return querySnapshot.docs.length;
  }

  // Get favorite counts for multiple blogs
  Future<Map<String, int>> getFavoriteCounts(List<String> blogIds) async {
    Map<String, int> counts = {};

    for (String blogId in blogIds) {
      counts[blogId] = await getFavoriteCount(blogId);
    }

    return counts;
  }

  // Toggle favorite status
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
