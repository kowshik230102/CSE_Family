// batch_list_screen.dart
// Main screen to display all batches (call this from your Batch icon)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'batch_list_controller.dart';
import 'batch_list_view.dart';

class BatchListScreen extends StatelessWidget {
  const BatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BatchListController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Batches'),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: BatchListView(),
        ),
      ),
    );
  }
}