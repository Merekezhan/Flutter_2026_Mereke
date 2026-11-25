import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> readToken() {
    return _storage.read(key: 'token');
  }

  Future<void> clear() async {
    await _storage.delete(key: 'token');
  }
}
