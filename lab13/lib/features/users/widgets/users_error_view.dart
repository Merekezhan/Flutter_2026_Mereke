import 'package:flutter/material.dart';
import '../../../core/api/api_exception.dart';
import 'offline_banner.dart';

class UsersErrorView extends StatelessWidget {
  const UsersErrorView({super.key, required this.error, required this.onRetry});
  final ApiException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error is NoConnectionException)
              const OfflineBanner()
            else
              const Text('Something went wrong'),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}
