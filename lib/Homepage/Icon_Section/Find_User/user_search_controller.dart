// user_search_controller.dart
// Handles the business logic for user search
// Manages Firestore queries and search functionality

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchController with ChangeNotifier {
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String _lastSearchTerm = '';

  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  Future<void> searchUsers(String searchTerm) async {
    if (searchTerm.isEmpty || searchTerm == _lastSearchTerm) return;
    
    _lastSearchTerm = searchTerm;
    _isSearching = true;
    notifyListeners();

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      
      // Search by name (case insensitive)
      final nameQuery = usersCollection
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .limit(10);

      // Search by ID (exact match)
      final idQuery = usersCollection
          .where('id', isEqualTo: searchTerm)
          .limit(1);

      final nameResults = await nameQuery.get();
      final idResults = await idQuery.get();

      _searchResults = [
        ...idResults.docs.map((doc) => doc.data()),
        ...nameResults.docs.map((doc) => doc.data()),
      ];

      // Remove duplicates
      _searchResults = _searchResults.toSet().toList();
    } catch (e) {
      debugPrint('Search error: $e');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
}