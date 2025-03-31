// user_search_results.dart
// Displays the search results in a scrollable list
// Shows loading indicator during search

import 'package:flutter/material.dart';
import 'user_search_controller.dart';
import 'user_card_widget.dart';

class UserSearchResults extends StatelessWidget {
  final UserSearchController controller;

  const UserSearchResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.searchResults.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        }

        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final user = controller.searchResults[index];
            return UserCardWidget(user: user);
          },
        );
      },
    );
  }
}