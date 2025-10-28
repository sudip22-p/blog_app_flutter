import 'package:blog_app/modules/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Send password reset email
  @override
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

  // Send email verification
  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No user is currently signed in.';
      }

      if (user.emailVerified) {
        throw 'Email is already verified.';
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'too-many-requests':
          throw 'Too many verification emails sent. Please wait before requesting another.';
        default:
          throw 'Failed to send verification email. Please try again.';
      }
    } catch (e) {
      if (e.toString().contains('Email is already verified')) {
        rethrow;
      }
      throw 'Failed to send verification email.';
    }
  }

  // Delete current user account
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No user is currently signed in.';
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw 'For security reasons, please sign out & sign in again before deleting your account.';
        case 'user-disabled':
          throw 'This account has been disabled and cannot be deleted.';
        case 'user-not-found':
          throw 'Account not found.';
        default:
          throw 'Failed to delete account: ${e.message ?? 'Unknown error'}';
      }
    } catch (e) {
      if (e.toString().contains('No user is currently signed in')) {
        rethrow;
      }
      throw 'Failed to delete account. Please try again.';
    }
  }
}
