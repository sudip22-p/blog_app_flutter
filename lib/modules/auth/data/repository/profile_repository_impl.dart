import 'dart:io';
import 'package:blog_app/common/common.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  // Update user display name
  @override
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
      } else {
        throw 'No user is currently signed in.';
      }
    } catch (e) {
      throw 'Failed to update display name: $e';
    }
  }

  // Pick image and update photo URL
  @override
  Future<void> updateProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile == null) {
        throw 'No image selected.';
      }

      final user = _auth.currentUser;
      if (user == null) {
        throw 'No user is currently signed in.';
      }

      // Upload to Cloudinary using the service
      final imageFile = File(pickedFile.path);
      final imageUrl = await _cloudinaryService.uploadProfilePicture(
        imageFile,
        user.uid,
      );

      // Update Firebase Auth photo URL
      await user.updatePhotoURL(imageUrl);
      await user.reload();
    } catch (e) {
      throw 'Failed to update profile picture: $e';
    }
  }

  // Get current user profile data
  @override
  Future<UserProfileEntity> getCurrentUserProfile() async {
    try {
      // Latest user data
      await _auth.currentUser?.reload();

      final user = _auth.currentUser;
      if (user == null) return UserProfileEntity.emptyEntity();
      UserProfileModel userProfile = UserProfileMapper.fromFirebaseUserToModel(
        user,
      );
      return UserProfileMapper.fromModelToEntity(userProfile);
    } catch (e) {
      return UserProfileEntity.emptyEntity();
    }
  }

  // Get user display name
  @override
  Future<String> getUserDisplayName() async {
    final user = _auth.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    if (user?.email != null && user!.email!.isNotEmpty) {
      return user.email!.split('@')[0]; // email prefix
    }
    return 'User';
  }
}
