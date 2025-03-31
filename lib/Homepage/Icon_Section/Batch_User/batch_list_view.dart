// batch_list_view.dart
// Displays the list of batches

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'batch_list_controller.dart';
import 'batch_users_screen.dart';

class BatchListView extends StatelessWidget {
  const BatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BatchListController>(context);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(controller.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.batches.isEmpty) {
      return const Center(child: Text('No batches found'));
    }

    return ListView.builder(
      itemCount: controller.batches.length,
      itemBuilder: (context, index) {
        final batch = controller.batches[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(batch),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BatchUsersScreen(batchName: batch),
                ),
              );
            },
          ),
        );
      },
    );
  }
}