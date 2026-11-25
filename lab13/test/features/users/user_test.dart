import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice13/features/users/user.dart';

const rawUser = '''{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light", "suite": "Apt. 556", "city": "Gwenborough",
    "zipcode": "92998-3874", "geo": {"lat": "-37.3159", "lng": "81.1496"}
  }
}''';

void main() {
  group('User.fromJson', () {
    test('parses name, city and string latitude', () {
      final user = User.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
      expect(user.name, 'Leanne Graham');
      expect(user.address.city, 'Gwenborough');
      expect(double.parse(user.address.geo.lat), -37.3159);
    });

    test('rejects string id', () {
      final json = jsonDecode(rawUser) as Map<String, dynamic>;
      json['id'] = '1';
      expect(() => User.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('reproduces malformed numeric latitude in Geo.fromJson', () {
      expect(() => Geo.fromJson({'lat': -37.3159, 'lng': '81.1496'}), throwsA(isA<TypeError>()));
    });
  });
}
