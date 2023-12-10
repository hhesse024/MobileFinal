import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Key names for storing data
  String _usernameKey = 'username';
  String _passwordKey = 'password';

  SecureStorage();

  // Save username and password securely
  Future<void> saveCredentials(String username, String password) async {
    await _secureStorage.write(key: _usernameKey, value: username);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  // Retrieve username from secure storage
  Future<String?> getUsername() async {
    return await _secureStorage.read(key: _usernameKey);
  }

  // Retrieve password from secure storage
  Future<String?> getPassword() async {
    return await _secureStorage.read(key: _passwordKey);
  }
}
