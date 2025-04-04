import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Profile/profile_image_service.dart';
import 'Profile/profile_image_widget.dart';
import 'Profile/user_info_widget.dart';
import 'Profile/user_repository.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isEditing = false;
  bool isLoading = true;
  String errorMessage = '';
  File? profileImage;

  // User data
  String name = "";
  String id = "";
  String reg = "";
  String session = "";
  String batch = "";
  String email = "";
  String address = "";
  String contactNo = "";
  String profileImageUrl = "";

  // Controllers
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController regController;
  late TextEditingController sessionController;
  late TextEditingController batchController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController contactController;

  // Services
  final ProfileImageService imageService = ProfileImageService();
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.photos.request();
      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Photo library permission is required')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    idController = TextEditingController();
    regController = TextEditingController();
    sessionController = TextEditingController();
    batchController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    contactController = TextEditingController();
  }

  void _disposeControllers() {
    nameController.dispose();
    idController.dispose();
    regController.dispose();
    sessionController.dispose();
    batchController.dispose();
    emailController.dispose();
    addressController.dispose();
    contactController.dispose();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated. Please login again.');
      }

      email = user.email ?? "No email";
      emailController.text = email;

      final userData = await userRepository.getUserData(user.uid);

      if (mounted) {
        setState(() {
          name = userData['name']?.toString() ?? "";
          id = userData['id']?.toString() ?? "";
          reg = userData['reg']?.toString() ?? "";
          session = userData['session']?.toString() ?? "";
          batch = userData['batch']?.toString() ?? "";
          address = userData['address']?.toString() ?? "";
          contactNo = userData['contactNo']?.toString() ?? "";
          profileImageUrl = userData['profileImageUrl']?.toString() ?? "";

          // Update all controllers
          nameController.text = name;
          idController.text = id;
          regController.text = reg;
          sessionController.text = session;
          batchController.text = batch;
          emailController.text = email;
          addressController.text = address;
          contactController.text = contactNo;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleImagePick() async {
    try {
      final pickedImage = await imageService.pickImage();
      if (pickedImage == null) return;

      if (!mounted) return;
      setState(() {
        isLoading = true;
        profileImage = pickedImage;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final imageUrl =
          await imageService.uploadProfileImage(pickedImage, user.uid);
      await userRepository.updateProfileImageUrl(user.uid, imageUrl);

      if (mounted) {
        setState(() {
          profileImageUrl = imageUrl;
          profileImage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update image: ${e.toString()}')),
        );
        debugPrint('Image upload error: $e');
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() {
        isLoading = true;
      });

      await userRepository.updateUserData(user.uid, {
        'name': nameController.text,
        'id': idController.text,
        'reg': regController.text,
        'session': sessionController.text,
        'batch': batchController.text,
        'address': addressController.text,
        'contactNo': contactController.text,
      });

      if (mounted) {
        setState(() {
          isEditing = false;
          name = nameController.text;
          id = idController.text;
          reg = regController.text;
          session = sessionController.text;
          batch = batchController.text;
          address = addressController.text;
          contactNo = contactController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Try Again",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 237, 251, 251),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileImageWidget(
              imageUrl: profileImageUrl,
              localImage: profileImage,
              onCameraPressed: _handleImagePick,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    UserInfoWidget(
                      label: "Full Name",
                      value: name,
                      controller: nameController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Student ID",
                      value: id,
                      controller: idController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Registration",
                      value: reg,
                      controller: regController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Session",
                      value: session,
                      controller: sessionController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Batch",
                      value: batch,
                      controller: batchController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Email",
                      value: email,
                      controller: emailController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Address",
                      value: address,
                      controller: addressController,
                      isEditing: isEditing,
                    ),
                    const Divider(height: 24),
                    UserInfoWidget(
                      label: "Contact",
                      value: contactNo,
                      controller: contactController,
                      isEditing: isEditing,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isEditing) ...[
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                        nameController.text = name;
                        idController.text = id;
                        regController.text = reg;
                        sessionController.text = session;
                        batchController.text = batch;
                        addressController.text = address;
                        contactController.text = contactNo;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      side: BorderSide(color: Colors.blue.shade800),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                ElevatedButton(
                  onPressed: () {
                    if (isEditing) {
                      _saveProfile();
                    } else {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Save Changes" : "Edit Profile",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
