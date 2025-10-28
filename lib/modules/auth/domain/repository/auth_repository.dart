import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  );

  Future<UserCredential?> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  Future<void> sendEmailVerification();

  Future<void> updateDisplayName(String displayName);

  Future<void> updateProfilePicture();

  Future<UserProfileEntity> getCurrentUserProfile();

  Future<String> getUserDisplayName();

  Future<void> deleteAccount();
}
