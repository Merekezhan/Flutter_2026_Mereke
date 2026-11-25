import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(
    this._client,
    this._store, {
    this.host = 'jsonplaceholder.typicode.com',
  });

  final http.Client _client;
  final SecureStore _store;
  final String host;

  Future<Map<String, String>> _headers() async {
    return {
      'Accept': 'application/json',
      if (await _store.readToken() case final token?)
        'Authorization': 'Bearer $token',
    };
  }

  Uri uri(String path, [Map<String, String>? query]) {
    return Uri.https(host, path, query);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        developer.log(
          '${response.request?.method} '
          '${response.request?.url} '
          '${response.statusCode}',
          name: 'api',
        );
      }

      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response response) {
    switch (response.statusCode) {
      case 401:
        throw const UnauthorizedException();

      case 404:
        throw const NotFoundException();

      default:
        if (response.statusCode >= 500) {
          throw ServerException(response.statusCode);
        }

        if (response.statusCode >= 400) {
          throw BadResponseException('HTTP ${response.statusCode}');
        }
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException catch (e) {
      throw BadResponseException(e.toString());
    }
  }

  Future<dynamic> get(String path, [Map<String, String>? query]) async {
    final headers = await _headers();

    final response = await _send(
      () => _client.get(uri(path, query), headers: headers),
    );

    _check(response);

    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    final headers = await _headers();

    final response = await _send(
      () => _client.post(
        uri(path),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ),
    );

    _check(response);

    if (response.statusCode != 201) {
      throw BadResponseException('Expected 201, got ${response.statusCode}');
    }

    return _decode(response);
  }
}
