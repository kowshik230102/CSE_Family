// user_card_widget.dart
// Displays individual user cards in search results
// Shows user name, ID, and profile picture

import 'package:flutter/material.dart';

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
          // Navigate to user profile
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => UserProfileScreen(userId: user['id'])
          // ));
        },
      ),
    );
  }
}