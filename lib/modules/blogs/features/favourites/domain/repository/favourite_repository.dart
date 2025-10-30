import 'package:blog_app/modules/blogs/blogs.dart';

abstract class FavouriteRepository {
  Future<List<FavouriteEntity>> getUserFavoritesCollection(String userId);

  Future<List<BlogEntity>> getUserFavoriteBlogs(String userId);

  Future<bool> toggleFavorite(String userId, String blogId);
}
