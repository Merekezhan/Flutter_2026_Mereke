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

  Future<void> load() async {
    if (loading) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser({
    required String name,
    required String username,
    required String email,
  }) async {
    if (saving) return false;

    saving = true;
    notifyListeners();

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
      notifyListeners();
      return true;
    } on ApiException {
      rethrow;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  Future<User> getUser(int id) {
    return _repo.getById(id);
  }
}
