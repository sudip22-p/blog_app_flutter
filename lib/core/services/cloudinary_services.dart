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

  Future<String> uploadProfilePicture(File image, String userId) async {
    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        image.path,
        folder: 'blogs/profile_pictures',
        publicId: 'user_$userId',
      ),
    );
    return response.secureUrl;
  }
}
