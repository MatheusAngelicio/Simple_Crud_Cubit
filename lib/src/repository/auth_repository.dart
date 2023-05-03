abstract class AuthRepository {
  Stream<String?> get onAuthStateChanged;

  Future<void> signOut();
}
