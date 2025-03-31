// user_card_widget.dart
// Fixed to properly pass user UID when navigating to profile

import 'package:flutter/material.dart';
import 'user_profile_screen.dart';

class UserCardWidget extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
          radius: 25,
          child: user['profileImageUrl'] == null 
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(user['name'] ?? 'No name'),
        subtitle: Text('ID: ${user['id'] ?? 'N/A'}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Use the document ID (uid) as the primary identifier
          final userId = user['uid'] ?? '';
          if (userId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User ID not found')),
            );
            return;
          }
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(userId: userId),
            ),
          );
        },
      ),
    );
  }
}