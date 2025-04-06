// ignore: file_names
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
        //backgroundColor: Colors.white, // Set background color to white
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black), // Black back icon
        //   onPressed: () {
        //     Navigator.pop(context); // Or your custom back navigation
        //   },
        // ),
        title: Center(
          child: Text(
            "CSE FAMILY",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: Colors.black),
          //   onPressed: () {
          //     // TODO: Implement search functionality
          //   },
          // ),
          // SizedBox(width: 15),
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
