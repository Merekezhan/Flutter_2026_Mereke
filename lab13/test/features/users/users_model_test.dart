import 'package:flutter_test/flutter_test.dart';
import 'package:practice13/core/api/api_exception.dart';
import 'package:practice13/features/users/users_model.dart';
import '../../fakes/fake_user_repository.dart';

void main() {
  group('UsersModel', () {
    test('load gets two users', () async {
      final model = UsersModel(FakeUserRepository());
      await model.load();
      expect(model.items, hasLength(2));
      expect(model.loading, isFalse);
      expect(model.error, isNull);
      model.dispose();
    });

    test('NoConnection sets error', () async {
      final model = UsersModel(FakeUserRepository(fail: true));
      await model.load();
      expect(model.error, isA<NoConnectionException>());
      expect(model.loading, isFalse);
      model.dispose();
    });
  });
}
