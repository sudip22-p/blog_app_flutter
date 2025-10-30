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
  @override
  String toString() {
    return 'UserProfileModel(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, emailVerified: $emailVerified, createdAt: $createdAt)';
  }
}
