import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final bool emailVerified;
  final DateTime createdAt;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.emailVerified,
    required this.createdAt,
  });
  static UserProfileEntity emptyEntity() {
    return UserProfileEntity(
      uid: '',
      email: '',
      displayName: '',
      photoURL: '',
      emailVerified: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object> get props => [
    uid,
    email,
    displayName,
    photoURL,
    emailVerified,
    createdAt,
  ];
}
