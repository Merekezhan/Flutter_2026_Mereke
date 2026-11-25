import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);
  final UserRepository _repo;

  List<User> items = [];
  bool loading = false;
  ApiException? error;
  String filter = '';

  List<User> get visibleItems => items
      .where((u) => u.name.toLowerCase().contains(filter.toLowerCase()))
      .toList();

  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      items = (await _repo.getAll()).items;
    } on ApiException catch (e) {
      error = e;
      developer.log('Users load failed: $e', name: 'UsersModel');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
