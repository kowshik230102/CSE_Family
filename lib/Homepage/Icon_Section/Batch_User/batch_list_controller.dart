// batch_list_controller.dart
// Handles fetching and managing batch data

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BatchListController with ChangeNotifier {
  List<String> _batches = [];
  bool _isLoading = true;
  String? _error;

  List<String> get batches => _batches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BatchListController() {
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    try {
      _isLoading = true;
      notifyListeners();

      final query = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('batch')
          .get();

      // Extract unique batches
      _batches = query.docs
          .map((doc) => doc['batch']?.toString() ?? 'Unknown')
          .toSet()
          .toList()
        ..sort();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load batches: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadBatches();
  }
}
