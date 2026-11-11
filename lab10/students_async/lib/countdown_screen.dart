import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Stream<int> _stream;

  @override
  void initState() {
    super.initState();
    _stream = countdown(10);
  }

  void _restart() {
    setState(() {
      _stream = countdown(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Center(
        child: StreamBuilder<int>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Countdown error');
            }

            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _restart,
                  child: const Text('Restart'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
