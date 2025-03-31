import 'package:flutter/material.dart';
import 'Icon_Section/IconSection.dart';
import 'PostSection/CreatePostSection.dart';
import 'CreateFeedSection.dart';
import 'package:csefamily/Homepage/Appbar/Menu_Bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 229, 146),
        elevation: 0,
        title: Center(
          child: Text(
            "CSE FAMILY",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          SizedBox(width: 15),
          MenuButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IconSection(), // ✅ New Icon Section
            Divider(),
            CreatePostSection(),
            Divider(),
            PostFeed(), // ✅ Separated Post Feed Widget
          ],
        ),
      ),
    );
  }
}
