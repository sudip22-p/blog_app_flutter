import 'dart:io';
import 'package:blog_app/common/services/cloudinary_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CloudinaryService _cloudinaryService = CloudinaryService();

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

  // Update user display name
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

  // Update user photo URL
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePhotoURL(photoURL);
        await user.reload();
      } else {
        throw 'No user is currently signed in.';
      }
    } catch (e) {
      throw 'Failed to update profile picture: $e';
    }
  }

  // Pick image and update photo URL
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
      await updatePhotoURL(imageUrl);
    } catch (e) {
      throw 'Failed to update profile picture: $e';
    }
  }

  // Get current user profile data
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      // Ensure we have the latest user data
      await _auth.currentUser?.reload();

      final user = _auth.currentUser;
      if (user == null) return null;

      return {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'createdAt': user.metadata.creationTime,
      };
    } catch (e) {
      return null;
    }
  } // Check if user is signed in

  bool get isSignedIn => _auth.currentUser != null;

  // Get user display name with fallback
  String getUserDisplayName() {
    final user = _auth.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    if (user?.email != null && user!.email!.isNotEmpty) {
      return user.email!.split('@')[0]; // Use email prefix as fallback
    }
    return 'User';
  }

  // Delete current user account
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
          throw 'For security reasons, please sign in again before deleting your account.';
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
