import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/features/users/user.dart';

void main() {
  test('User JSON round-trip', () {
    const user = User(
      id: 1,
      name: 'Test User',
      username: 'test',
      email: 'test@example.com',
      phone: '+123456789',
      website: null,
      address: Address(
        street: 'Test Street',
        suite: 'Apt 1',
        city: 'Almaty',
        zipcode: '050000',
        geo: Geo(lat: 43.2, lng: 76.9),
      ),
      company: (name: 'Test Company', catchPhrase: 'Hello world'),
    );

    final restored = User.fromJson(user.toJson());

    expect(restored.toJson(), user.toJson());
    expect(restored.phoneDigits, '+123456789');
  });
}
