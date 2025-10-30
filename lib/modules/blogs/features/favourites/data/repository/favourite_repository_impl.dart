import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FavouriteRepository)
class FavouriteRepositoryImpl implements FavouriteRepository {
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance
      .collection('favorites');
  final CollectionReference _blogsCollection = FirebaseFirestore.instance
      .collection('blogs');

  @override
  Future<List<FavouriteEntity>> getUserFavoritesCollection(
    String userId,
  ) async {
    try {
      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final FavouriteModel favourite = FavouriteMapper.fromJsonToModel(
          data,
          doc.id,
        );
        return FavouriteMapper.fromModelToEntity(favourite);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BlogEntity>> getUserFavoriteBlogs(String userId) async {
    try {
      final favorites = await getUserFavoritesCollection(userId);
      final blogIds = favorites.map((f) => f.blogId).toList();

      if (blogIds.isEmpty) return [];

      final blogsQuery = await _blogsCollection
          .where(FieldPath.documentId, whereIn: blogIds)
          .get();

      return blogsQuery.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final BlogModel blog = BlogMapper.fromJsonToModel(data, doc.id);
        return BlogMapper.fromModelToEntity(blog);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addToFavorites(String userId, String blogId) async {
    await _favoritesCollection.add({
      'userId': userId,
      'blogId': blogId,
      'createdAt': DateTime.now(),
    });
  }

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

  Future<bool> checkFavourite(String userId, String blogId) async {
    final querySnapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('blogId', isEqualTo: blogId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<bool> toggleFavorite(String userId, String blogId) async {
    final isFav = await checkFavourite(userId, blogId);

    if (isFav) {
      await removeFromFavorites(userId, blogId);
      return false;
    } else {
      await addToFavorites(userId, blogId);
      return true;
    }
  }
}
