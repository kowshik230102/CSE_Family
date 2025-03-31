// user_repository.dart
// Handles all Firestore operations for user data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get()
          .timeout(const Duration(seconds: 15));

      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      } else {
        // Create document with all fields if it doesn't exist
        final user = FirebaseAuth.instance.currentUser;
        await _firestore.collection('users').doc(userId).set({
          'email': user?.email ?? "",
          'name': "",
          'id': "",
          'reg': "",
          'session': "",
          'batch': "",
          'address': "",
          'contactNo': "",
          'profileImageUrl': "",
        }, SetOptions(merge: true));
        return {
          'email': user?.email ?? "",
          'name': "",
          'id': "",
          'reg': "",
          'session': "",
          'batch': "",
          'address': "",
          'contactNo': "",
          'profileImageUrl': "",
        };
      }
    } catch (e) {
      throw Exception('Failed to load user data: ${e.toString()}');
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
  }

  Future<void> updateProfileImageUrl(String userId, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to update profile image URL: ${e.toString()}');
    }
  }
}