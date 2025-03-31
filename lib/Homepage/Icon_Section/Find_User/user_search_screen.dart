// user_search_screen.dart
// Main screen for user search functionality
// Call this from your Find icon's onPressed

import 'package:flutter/material.dart';
import 'user_search_controller.dart';
import 'user_search_results.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final UserSearchController _controller = UserSearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Users'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _controller.searchUsers,
            ),
          ),
          Expanded(
            child: UserSearchResults(controller: _controller),
          ),
        ],
      ),
    );
  }
}