// batch_users_screen.dart
// Added proper app bar and error handling

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'batch_users_controller.dart';
import 'batch_users_view.dart';

class BatchUsersScreen extends StatelessWidget {
  final String batchName;

  const BatchUsersScreen({super.key, required this.batchName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BatchUsersController(batchName),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Batch $batchName',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<BatchUsersController>(context, listen: false)
                    .refresh();
              },
            ),
          ],
        ),
        body: const BatchUsersView(),
      ),
    );
  }
}