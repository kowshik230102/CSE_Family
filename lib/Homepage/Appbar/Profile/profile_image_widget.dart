// profile_image_widget.dart
// Contains the profile image display and camera button UI

import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final File? localImage;
  final VoidCallback onCameraPressed;
  final double radius;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.localImage,
    required this.onCameraPressed,
    this.radius = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue.shade200,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: _getProfileImage(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
              onPressed: onCameraPressed,
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage() {
    if (localImage != null) {
      return FileImage(localImage!);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return const AssetImage("assets/profile.jpg");
  }
}