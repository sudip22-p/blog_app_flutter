class BlogModel {
  final String? id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String coverImageUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.coverImageUrl,
    required this.tags,
    required this.createdAt,
    required this.lastUpdatedAt,
  });
}
