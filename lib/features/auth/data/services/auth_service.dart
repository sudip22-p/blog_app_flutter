import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email address.';
        case 'wrong-password':
          throw 'Incorrect password.';
        case 'invalid-email':
          throw 'Invalid email address format.';
        case 'user-disabled':
          throw 'This account has been disabled.';
        case 'too-many-requests':
          throw 'Too many failed attempts. Please try again later.';
        default:
          throw 'Sign in failed. Please try again.';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Create account with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the display name for the newly created user
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        // Reload user to get updated data
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw 'Password is too weak. Use at least 6 characters.';
        case 'email-already-in-use':
          throw 'An account already exists with this email.';
        case 'invalid-email':
          throw 'Invalid email address format.';
        default:
          throw 'Account creation failed. Please try again.';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw 'Google sign-in failed. Please try again.';
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No account found with this email address.';
        case 'invalid-email':
          throw 'Invalid email address format.';
        default:
          throw 'Failed to send reset email. Please try again.';
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw 'Sign out failed. Please try again.';
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw 'Failed to send verification email.';
    }
  }

  // Delete current user account (minimal implementation)
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw 'Please sign in again before deleting your account.';
      }
      throw 'Failed to delete account. Please try again.';
    } catch (e) {
      throw 'Failed to delete account. Please try again.';
    }
  }
}
