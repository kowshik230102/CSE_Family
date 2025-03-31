import 'package:csefamily/Entry/signup_page.dart';
import 'package:csefamily/Homepage/HomePage.dart';
import 'package:flutter/material.dart';

import 'Batch_User/batch_list_screen.dart';
import 'Find_User/user_search_screen.dart';

class IconSection extends StatelessWidget {
  const IconSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        children: [
          // First Row of Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(Icons.home, "Home", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              }),
              _buildIconButton(Icons.group, "Batch", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BatchListScreen()),
                );
              }),
              _buildIconButton(Icons.person_search, "Find", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserSearchScreen(),
                  ),
                );
              }),
              _buildIconButton(Icons.notifications, "Alerts", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
              _buildIconButton(Icons.message, "SMS", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          // Second Row of Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(Icons.announcement, "Notice", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
              _buildIconButton(Icons.grade, "Result", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
              _buildIconButton(Icons.emoji_events, "Achieve", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
              _buildIconButton(Icons.sports, "Sports", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
              _buildIconButton(Icons.more_horiz, "Other", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
