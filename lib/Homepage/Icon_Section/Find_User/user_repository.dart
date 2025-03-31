// user_repository.dart
// Handles all Firestore operations related to users
// Used by UserSearchController for user data access

import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final results = await _firestore.collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();

      return results.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}