class UserProfileModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final bool emailVerified;
  final DateTime createdAt;

  const UserProfileModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.emailVerified,
    required this.createdAt,
  });

  // Get display name or email
  String get displayNameOrEmail {
    if (displayName != '') {
      return displayName;
    }
    return email;
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
