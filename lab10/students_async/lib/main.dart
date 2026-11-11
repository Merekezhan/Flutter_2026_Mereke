import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'students_screen.dart';
import 'students_future_screen.dart';
import 'countdown_screen.dart';

void main() {
  runApp(const StudentsApp());
}

class StudentsApp extends StatelessWidget {
  const StudentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Practice 10',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FakeApi _byHandApi = FakeApi();

  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice 10'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 72, color: Colors.deepPurple),

              const SizedBox(height: 16),

              const Text(
                'The Data Arrives Later',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32),

              // Level 2 — By hand
              ElevatedButton(
                onPressed: () {
                  _open(StudentsScreen(api: _byHandApi));
                },
                child: const Text('By hand'),
              ),

              const SizedBox(height: 12),

              // Level 3 — FutureBuilder
              ElevatedButton(
                onPressed: () {
                  _open(const StudentsFutureScreen());
                },
                child: const Text('FutureBuilder'),
              ),

              const SizedBox(height: 12),

              // Level 4 — Countdown
              ElevatedButton(
                onPressed: () {
                  _open(const CountdownScreen());
                },
                child: const Text('Countdown'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
