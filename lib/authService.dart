part of "demo.dart";

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyRememberMe = 'remember_me';

  static Future<void> saveLoginData(String username, String password) async {
    bool rememberMe = true;
    if (rememberMe) {
      await _storage.write(key: _keyUsername, value: username);
      await _storage.write(key: _keyPassword, value: password);
    }
    await _storage.write(key: _keyRememberMe, value: rememberMe.toString());
  }

  static Future<Map<String, dynamic>> loadLoginData() async {
    final rememberMe = await _storage.read(key: _keyRememberMe);
    if (rememberMe == 'true') {
      return {
        'username': await _storage.read(key: _keyUsername),
        'password': await _storage.read(key: _keyPassword),
        'rememberMe': true,
      };
    }
    return {'rememberMe': false};
  }

  static Future<void> clearLoginData() async {
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
    await _storage.delete(key: _keyRememberMe);
  }
}