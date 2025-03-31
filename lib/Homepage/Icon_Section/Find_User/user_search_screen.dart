// user_search_screen.dart
// Added better error handling and search feedback

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_search_controller.dart';
import 'user_search_results.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'name';
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserSearchController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Users'),
          centerTitle: true,
        ),
        body: Consumer<UserSearchController>(
          builder: (context, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by ${_searchType == 'name' ? 'name' : 'ID'}...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        controller.searchUsers('', _searchType);
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (query) {
                              _lastQuery = query;
                              if (query.length > 2) { // Start searching after 3 characters
                                controller.searchUsers(query, _searchType);
                              } else if (query.isEmpty) {
                                controller.searchUsers('', _searchType);
                              }
                            },
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.filter_list),
                          onSelected: (value) {
                            setState(() {
                              _searchType = value;
                              if (_lastQuery.isNotEmpty) {
                                controller.searchUsers(_lastQuery, _searchType);
                              }
                            });
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'name',
                              child: Text('Search by Name'),
                            ),
                            const PopupMenuItem(
                              value: 'id',
                              child: Text('Search by ID'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Search Status
                  if (controller.isSearching)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    )
                  else if (controller.lastError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        controller.lastError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  const Expanded(child: UserSearchResults()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}