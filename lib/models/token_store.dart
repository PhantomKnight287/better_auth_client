abstract class TokenStore {
  Future<void> saveToken(String? token);
  Future<String> getToken();
  Future<String> getAdminToken();
  Future<void> saveAdminToken(String? token);
}
