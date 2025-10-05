import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final _cloudinary = CloudinaryPublic(
    'dn8myhtjp',
    'blog_uploads',
    cache: false,
  );

  Future<String> uploadImage(File image) async {
    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(image.path, folder: 'blogs/uploads'),
    );
    return response.secureUrl;
  }
}
