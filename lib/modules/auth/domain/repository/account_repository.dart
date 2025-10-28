abstract class AccountRepository {
  Future<void> sendEmailVerification();
  
  Future<void> sendPasswordResetEmail(String email);

  Future<void> deleteAccount();
}
