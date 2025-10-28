import 'package:blog_app/modules/auth/domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? createdAt;

  const UserProfileModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.createdAt,
  });

  // Create UserProfileModel from Firebase User
  factory UserProfileModel.fromFirebaseUser(User user) {
    return UserProfileModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  // Create UserProfileModel from JSON (for future database storage)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt: (json['createdAt'] is DateTime)
          ? json['createdAt']
          : (json['createdAt'] != null
                ? DateTime.tryParse(json['createdAt'].toString())
                : null),
    );
  }

  // Convert to JSON (for future database storage)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static UserProfileEntity toUserProfileEntity(UserProfileModel profile) {
    return UserProfileEntity(
      uid: profile.uid,
      email: profile.email ?? '',
      displayName: profile.displayName ?? '',
      photoURL: profile.photoURL ?? '',
      emailVerified: profile.emailVerified,
      createdAt: profile.createdAt ?? DateTime.now(),
    );
  }

  static UserProfileModel fromUserProfileEntity(UserProfileEntity profile) {
    return UserProfileModel(
      uid: profile.uid,
      email: profile.email,
      displayName: profile.displayName,
      photoURL: profile.photoURL,
      emailVerified: profile.emailVerified,
      createdAt: profile.createdAt,
    );
  }

  // Copy with method for updates
  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? createdAt,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get display name or email fallback
  String get displayNameOrEmail {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }
    return email ?? 'User';
  }

  // Get first letter for avatar
  String get firstLetter {
    final name = displayNameOrEmail;
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  String toString() {
    return 'UserProfileModel(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, emailVerified: $emailVerified, createdAt: $createdAt)';
  }
}
