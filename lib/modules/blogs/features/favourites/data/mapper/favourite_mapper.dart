import 'package:blog_app/modules/blogs/blogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteMapper {
  static FavouriteEntity fromModelToEntity(FavouriteModel model) {
    return FavouriteEntity(
      id: model.id,
      userId: model.userId,
      blogId: model.blogId,
      createdAt: model.createdAt,
    );
  }

  static FavouriteModel fromEntityToModel(FavouriteEntity entity) {
    return FavouriteModel(
      id: entity.id,
      userId: entity.userId,
      blogId: entity.blogId,
      createdAt: entity.createdAt,
    );
  }

  static Map<String, dynamic> fromModelToJson(FavouriteModel model) {
    return {
      'id': model.id,
      'userId': model.userId,
      'blogId': model.blogId,
      'createdAt': model.createdAt.toIso8601String(),
    };
  }

  static FavouriteModel fromJsonToModel(Map<String, dynamic> json, String id) {
    return FavouriteModel(
      id: id,
      userId: json['userId'] as String,
      blogId: json['blogId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
