// batch_users_view.dart
// Improved UI with better error handling

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Find_User/user_profile_screen.dart';
import 'batch_users_controller.dart';

class BatchUsersView extends StatelessWidget {
  const BatchUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BatchUsersController>(context);
    final batchName = controller.batchName;

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              controller.error!,
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (controller.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No users in batch $batchName',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          final userData = user.data() as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue[100],
                backgroundImage: userData['profileImageUrl'] != null
                    ? NetworkImage(userData['profileImageUrl'])
                    : null,
                child: userData['profileImageUrl'] == null
                    ? Text(
                        userData['name'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              title: Text(
                userData['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'ID: ${userData['id'] ?? 'N/A'}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(
                      userId: user.id,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
