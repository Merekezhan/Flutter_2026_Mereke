import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practice13/core/api/api_client.dart';
import 'package:practice13/core/api/api_exception.dart';
import 'package:practice13/features/users/user_repository.dart';

void main() {
  group('HttpUserRepository + MockClient', () {
    test('404 maps to NotFoundException', () async {
      final client = MockClient((_) async => http.Response('{"error":"gone"}', 404));
      final repo = HttpUserRepository(ApiClient(client: client));
      await expectLater(repo.getById(99), throwsA(isA<NotFoundException>()));
      client.close();
    });

    test('500 maps to ServerException', () async {
      final client = MockClient((_) async => http.Response('error', 500));
      final repo = HttpUserRepository(ApiClient(client: client));
      await expectLater(repo.getById(99), throwsA(isA<ServerException>()));
      client.close();
    });

    test('SocketException maps to NoConnectionException', () async {
      final client = MockClient((_) async => throw const SocketException('down'));
      final repo = HttpUserRepository(ApiClient(client: client));
      await expectLater(repo.getById(99), throwsA(isA<NoConnectionException>()));
      client.close();
    });

    test('malformed numeric lat maps to BadResponseException', () async {
      final client = MockClient((_) async => http.Response('''{"id":1,"name":"Test","email":"test@example.com","address":{"city":"A","geo":{"lat":-37.3159,"lng":"81.1496"}}}''', 200));
      final repo = HttpUserRepository(ApiClient(client: client));
      await expectLater(repo.getById(1), throwsA(isA<BadResponseException>()));
      client.close();
    });
  });
}
