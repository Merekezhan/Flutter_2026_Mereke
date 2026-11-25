import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UsersResult {
  const UsersResult(this.items);
  final List<User> items;
}

abstract interface class UserRepository {
  Future<UsersResult> getAll();
  Future<User> getById(int id);
  Future<User> create(User draft);
}

class HttpUserRepository implements UserRepository {
  HttpUserRepository(this._api);
  final ApiClient _api;

  @override
  Future<UsersResult> getAll() async {
    try {
      final result = await _api.get('/users') as List<dynamic>;
      return UsersResult(result.map((v) => User.fromJson(v as Map<String, dynamic>)).toList());
    } on TypeError {
      throw const BadResponseException('users: invalid JSON type (lat must be a String)');
    }
  }

  @override
  Future<User> getById(int id) async {
    try {
      final result = await _api.get('/users/$id') as Map<String, dynamic>;
      return User.fromJson(result);
    } on TypeError {
      throw const BadResponseException('users: lat is not a String or other invalid field');
    }
  }

  @override
  Future<User> create(User draft) async {
    try {
      final result = await _api.post('/users', draft.toJson()) as Map<String, dynamic>;
      return User.fromJson(result);
    } on TypeError {
      throw const BadResponseException('users: invalid create response');
    }
  }
}
