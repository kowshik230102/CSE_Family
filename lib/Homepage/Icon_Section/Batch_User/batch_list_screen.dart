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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'All Batches',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          foregroundColor: Colors.black, // Black text and back icon
          //backgroundColor: Colors.white, // Optional: white background
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: BatchListView(),
        ),
      ),
    );
  }
}
