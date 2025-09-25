import "package:firebase_auth/firebase_auth.dart";

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        throw "The account already exists for that email.";
      } else {
        throw e.message ?? "An unknown sign up error occurred.";
      }
    } catch (e) {
      throw "An unknown error occurred.";
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        throw "Wrong password provided for that user.";
      } else {
        throw e.message ?? "An unknown login error occurred.";
      }
    } catch (e) {
      throw "An unknown error occurred.";
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw "Failed to log out.";
    }
  }
}
