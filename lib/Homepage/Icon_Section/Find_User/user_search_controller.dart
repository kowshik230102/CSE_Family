// user_search_controller.dart
// Fixed search queries to properly find users

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchController with ChangeNotifier {
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;
  String? _lastError;

  List<DocumentSnapshot> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get lastError => _lastError;

  Future<void> searchUsers(String query, String searchType) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isSearching = true;
    _lastError = null;
    notifyListeners();

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      Query queryRef;

      // Convert query to lowercase for case-insensitive search
      final searchQuery = query.toLowerCase();

      if (searchType == 'name') {
        queryRef = usersCollection
            .where('nameLowercase', isGreaterThanOrEqualTo: searchQuery)
            .where('nameLowercase', isLessThanOrEqualTo: '$searchQuery\uf8ff')
            .limit(20);
      } else {
        queryRef = usersCollection
            .where('id', isEqualTo: searchQuery)
            .limit(20);
      }

      final results = await queryRef.get();
      
      if (results.docs.isEmpty) {
        // Fallback search if no results found
        queryRef = usersCollection
            .orderBy(searchType == 'name' ? 'name' : 'id')
            .limit(20);
        
        final fallbackResults = await queryRef.get();
        _searchResults = fallbackResults.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final fieldValue = (data[searchType == 'name' ? 'name' : 'id'] ?? '').toString().toLowerCase();
          return fieldValue.contains(searchQuery);
        }).toList();
      } else {
        _searchResults = results.docs;
      }

    } catch (e) {
      _lastError = 'Search error: ${e.toString()}';
      _searchResults = [];
      debugPrint('Search error: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
}