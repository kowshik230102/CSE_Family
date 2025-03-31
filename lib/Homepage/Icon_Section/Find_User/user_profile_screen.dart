// user_profile_screen.dart
// Complete profile view with all user details

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Appbar/Profile/profile_image_widget.dart';
import '../../Appbar/Profile/user_info_widget.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileImageWidget(
                  imageUrl: user['profileImageUrl'],
                  localImage: null,
                  onCameraPressed: null,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        UserInfoWidget(
                          label: "Full Name",
                          value: user['name'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Student ID",
                          value: user['id'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Registration",
                          value: user['reg'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Session",
                          value: user['session'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Batch",
                          value: user['batch'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Email",
                          value: user['email'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Address",
                          value: user['address'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                        const Divider(height: 24),
                        UserInfoWidget(
                          label: "Contact",
                          value: user['contactNo'] ?? 'Not provided',
                          controller: null,
                          isEditing: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
