import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];

  ApiException? error;

  bool loading = false;
  bool saving = false;
  bool fromCache = false;
  bool _disposed = false;

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> load() async {
    if (loading) return;

    loading = true;
    error = null;

    _notify();

    try {
      final result = await _repo.getAll();

      items = result.items;
      fromCache = result.fromCache;
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      _notify();
    }
  }

  Future<bool> createUser({
    required String name,
    required String username,
    required String email,
  }) async {
    if (saving) return false;

    saving = true;
    _notify();

    try {
      final draft = User(
        id: 0,
        name: name,
        username: username,
        email: email,
        phone: '',
        website: null,
        address: const Address(
          street: '',
          suite: '',
          city: '',
          zipcode: '',
          geo: Geo(lat: 0, lng: 0),
        ),
        company: (name: '', catchPhrase: ''),
      );

      final created = await _repo.create(draft);

      items = [created, ...items];

      _notify();

      return true;
    } finally {
      saving = false;
      _notify();
    }
  }

  Future<User> getUser(int id) {
    return _repo.getById(id);
  }
}
