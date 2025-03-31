// batch_users_controller.dart
// Fixed batch users loading with proper error handling

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BatchUsersController with ChangeNotifier {
  final String batchName;
  List<DocumentSnapshot> _users = [];
  bool _isLoading = true;
  String? _error;

  List<DocumentSnapshot> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BatchUsersController(this.batchName) {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('batch', isEqualTo: batchName)
          .orderBy('name')
          .get();

      if (querySnapshot.docs.isEmpty) {
        _error = 'No users found in batch $batchName';
      } else {
        _users = querySnapshot.docs;
      }
    } catch (e) {
      _error = 'Failed to load users: ${e.toString()}';
      debugPrint('Error loading batch users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadUsers();
  }
}