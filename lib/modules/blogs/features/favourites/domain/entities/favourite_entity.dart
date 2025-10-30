class FavouriteEntity {
  final String id;
  final String userId;
  final String blogId;
  final DateTime createdAt;

  const FavouriteEntity({
    required this.id,
    required this.userId,
    required this.blogId,
    required this.createdAt,
  });
}
