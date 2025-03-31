// user_search_results.dart
// Improved results display with better empty states

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_search_controller.dart';
import 'user_profile_screen.dart';

class UserSearchResults extends StatelessWidget {
  const UserSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<UserSearchController>(context);

    if (controller.isSearching && controller.searchResults.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.lastError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              controller.lastError!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (controller.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No users found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching with different terms',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final userDoc = controller.searchResults[index];
        final user = userDoc.data() as Map<String, dynamic>;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          elevation: 1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              backgroundImage: user['profileImageUrl'] != null
                  ? NetworkImage(user['profileImageUrl'])
                  : null,
              child: user['profileImageUrl'] == null
                  ? Text(user['name'][0].toUpperCase())
                  : null,
            ),
            title: Text(user['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${user['id']}'),
                if (user['batch'] != null) Text('Batch: ${user['batch']}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    userId: userDoc.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
