import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'users_model.dart';
import 'user_detail_screen.dart';
import 'widgets/user_tile.dart';
import 'widgets/users_header.dart';
import 'widgets/users_filter_row.dart';
import 'widgets/users_empty_view.dart';
import 'widgets/users_error_view.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Practice 13')),
      body: Column(
        children: [
          const UsersHeader(),
          UsersFilterRow(onChanged: model.setFilter),
          Expanded(child: _content(context, model)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, UsersModel model) {
    if (model.loading) return const Center(child: CircularProgressIndicator());
    if (model.error case final error?) {
      return UsersErrorView(error: error, onRetry: () { model.load(); });
    }
    if (model.visibleItems.isEmpty) return const UsersEmptyView();
    return ListView.builder(
      itemCount: model.visibleItems.length,
      itemBuilder: (context, index) {
        final user = model.visibleItems[index];
        return UserTile(
          user: user,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => UserDetailScreen(user: user)),
          ),
        );
      },
    );
  }
}
