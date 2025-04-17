abstract class TokenStore {
  Future<void> saveToken(String? token);
  Future<String> getToken();
}
