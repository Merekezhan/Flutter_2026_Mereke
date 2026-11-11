import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/loading_view.dart';
import 'widgets/error_view.dart';
import 'widgets/empty_view.dart';
import 'widgets/student_list.dart';

class StudentsFutureScreen extends StatefulWidget {
  const StudentsFutureScreen({super.key});

  @override
  State<StudentsFutureScreen> createState() => _StudentsFutureScreenState();
}

class _StudentsFutureScreenState extends State<StudentsFutureScreen> {
  final FakeApi _api = FakeApi();

  // Not final because Retry needs a new Future.
  late Future<List<Student>> _future;

  bool _compact = false;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchStudents();
  }

  void _retry() {
    setState(() {
      _future = _api.fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureBuilder'),
        actions: [
          const Text('Compact'),
          Switch(
            value: _compact,
            onChanged: (value) {
              setState(() {
                _compact = value;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _future,
        // future: _api.fetchStudents(),
        builder: (context, snapshot) {
          // 1. Error
          if (snapshot.hasError) {
            return ErrorView(onRetry: _retry);
          }

          // 2. Loading
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }

          // 3. Empty
          final list = snapshot.data ?? const <Student>[];

          if (list.isEmpty) {
            return const EmptyView();
          }

          // 4. Data
          return StudentList(students: list, compact: _compact);
        },
      ),
    );
  }
}
