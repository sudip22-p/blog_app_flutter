import 'package:blog_app/modules/auth/auth.dart';

abstract class ProfileRepository {
  Future<void> updateDisplayName(String displayName);

  Future<void> updateProfilePicture();

  Future<UserProfileEntity> getCurrentUserProfile();

  Future<String> getUserDisplayName();
}
