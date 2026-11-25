import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';

import 'user.dart';
import 'users_cache.dart';

typedef UsersResult = ({List<User> items, bool fromCache});

class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Future<List<User>> _fetch() async {
    final dynamic data = await _api.get('/users');

    try {
      final list = data as List<dynamic>;

      return list.map((item) {
        return User.fromJson(item as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<UsersResult> getAll() async {
    try {
      final fresh = await _fetch();

      await _cache.save(fresh);

      return (items: fresh, fromCache: false);
    } on NoConnectionException {
      final saved = await _cache.load();

      if (saved == null) {
        rethrow;
      }

      return (items: saved, fromCache: true);
    }
  }

  Future<User> getById(int id) async {
    final dynamic data = await _api.get('/users/$id');

    try {
      return User.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    final dynamic data = await _api.post('/users', draft.toJson());

    try {
      return User.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw BadResponseException('create user: $e');
    }
  }
}
