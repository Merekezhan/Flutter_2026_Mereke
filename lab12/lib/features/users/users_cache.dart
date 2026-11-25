import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'user.dart';

class UsersCache {
  Future<File> _file() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/users.json');
  }

  Future<void> save(List<User> users) async {
    final file = await _file();

    final data = jsonEncode([for (final user in users) user.toJson()]);

    await file.writeAsString(data);
  }

  Future<List<User>?> load() async {
    final file = await _file();

    if (!await file.exists()) {
      return null;
    }

    final content = await file.readAsString();

    final data = jsonDecode(content) as List<dynamic>;

    return [
      for (final item in data) User.fromJson(item as Map<String, dynamic>),
    ];
  }
}
