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

  Future<void> signOut();
}
