import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client, this.host = 'https://jsonplaceholder.typicode.com'})
      : client = client ?? http.Client();
  final http.Client client;
  final String host;

  Future<dynamic> get(String path) => _send(() => client.get(Uri.parse('$host$path')));

  Future<dynamic> post(String path, Object body) => _send(
        () => client.post(
          Uri.parse('$host$path'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(body),
        ),
      );

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(const Duration(seconds: 10));
      _check(response.statusCode);
      return _decode(response.body);
    } on SocketException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on FormatException {
      throw const BadResponseException('Invalid JSON');
    }
  }

  void _check(int code) {
    if (code >= 200 && code < 300) return;
    if (code == 404) throw const NotFoundException();
    if (code == 401 || code == 403) throw const UnauthorizedException();
    if (code >= 500) throw ServerException(code);
    throw BadResponseException('HTTP $code');
  }

  dynamic _decode(String body) => body.isEmpty ? null : jsonDecode(body);
}
