import 'package:practice13/core/api/api_exception.dart';
import 'package:practice13/features/users/user.dart';
import 'package:practice13/features/users/user_repository.dart';

class FakeUserRepository implements UserRepository {
  FakeUserRepository({this.fail = false, this.delay = Duration.zero});
  final bool fail;
  final Duration delay;

  static const _address = Address(city: 'Almaty', geo: Geo(lat: '43.2', lng: '76.9'));
  static const _users = [
    User(id: 1, name: 'Amina', email: 'amina@example.com', address: _address),
    User(id: 2, name: 'Dana', email: 'dana@example.com', address: _address),
  ];

  Future<void> _wait() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (fail) throw const NoConnectionException();
  }

  @override
  Future<UsersResult> getAll() async { await _wait(); return const UsersResult(_users); }

  @override
  Future<User> getById(int id) async {
    await _wait();
    for (final user in _users) { if (user.id == id) return user; }
    throw const NotFoundException();
  }

  @override
  Future<User> create(User draft) async { await _wait(); return draft; }
}
