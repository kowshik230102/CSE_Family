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
          backgroundColor: Colors.white, // White app bar background
          elevation: 0, // Remove shadow if desired
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.black), // Black back icon
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Batch $batchName',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Black text color
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh,
                  color: Colors.black), // Black refresh icon
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
