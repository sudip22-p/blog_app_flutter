import 'package:blog_app/modules/auth/auth.dart';
import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileMapper {
  static UserProfileEntity fromModelToEntity(UserProfileModel userProfile) {
    return UserProfileEntity(
      uid: userProfile.uid,
      email: userProfile.email,
      displayName: userProfile.displayName,
      photoURL: userProfile.photoURL,
      emailVerified: userProfile.emailVerified,
      createdAt: userProfile.createdAt,
    );
  }

  static UserProfileModel fromEntityToModel(UserProfileEntity userProfile) {
    return UserProfileModel(
      uid: userProfile.uid,
      email: userProfile.email,
      displayName: userProfile.displayName,
      photoURL: userProfile.photoURL,
      emailVerified: userProfile.emailVerified,
      createdAt: userProfile.createdAt,
    );
  }

  static UserProfileModel fromJsonToModel(Map<String, dynamic> userProfile) {
    return UserProfileModel(
      uid: userProfile['uid'],
      email: userProfile['email'],
      displayName: userProfile['displayName'],
      photoURL: userProfile['photoURL'],
      emailVerified: userProfile['emailVerified'],
      createdAt: userProfile['createdAt'],
    );
  }

  static Map<String, dynamic> fromModelToJson(UserProfileModel userProfile) {
    return {
      'uid': userProfile.uid,
      'email': userProfile.email,
      'displayName': userProfile.displayName,
      'photoURL': userProfile.photoURL,
      'emailVerified': userProfile.emailVerified,
      'createdAt': userProfile.createdAt,
    };
  }

  static UserProfileModel fromFirebaseUserToModel(User user) {
    return UserProfileModel(
      uid: user.uid,
      email: user.email ?? "",
      displayName: user.displayName ?? "",
      photoURL: user.photoURL ?? "",
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }
}
