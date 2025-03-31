import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isEditing = false;
  File? _profileImage;
  final picker = ImagePicker();
  bool _isLoading = true;
  String _errorMessage = '';

  // User Details
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

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    regController.dispose();
    sessionController.dispose();
    batchController.dispose();
    emailController.dispose();
    addressController.dispose();
    contactController.dispose();
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

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated. Please login again.');
      }

      // Set email immediately from auth
      email = user.email ?? "No email";
      emailController.text = email;

      // Get user document with timeout
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .timeout(const Duration(seconds: 15));

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        if (!mounted) return;
        setState(() {
          name = data['name']?.toString() ?? "";
          id = data['id']?.toString() ?? "";
          reg = data['reg']?.toString() ?? "";
          session = data['session']?.toString() ?? "";
          batch = data['batch']?.toString() ?? "";
          address = data['address']?.toString() ?? "";
          contactNo = data['contactNo']?.toString() ?? "";
          profileImageUrl = data['profileImageUrl']?.toString() ?? "";

          // Update controllers
          nameController.text = name;
          idController.text = id;
          regController.text = reg;
          sessionController.text = session;
          batchController.text = batch;
          addressController.text = address;
          contactController.text = contactNo;
        });
      } else {
        // Create document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'email': email}, SetOptions(merge: true));
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Database error: ${e.message}';
      });
      debugPrint('Firebase error: ${e.message}');
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Request timed out. Please check your connection.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
      });
      debugPrint('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        if (!mounted) return;
        setState(() {
          _isLoading = true;
          _profileImage = File(pickedFile.path);
        });

        await _uploadImage();
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Storage error: ${e.message}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to pick image: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || _profileImage == null) return;

      // Create reference to storage location
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user.uid}.jpg');

      // Upload file
      await storageRef.putFile(_profileImage!);

      // Get download URL
      final String downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore with new URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': downloadUrl});

      if (mounted) {
        setState(() {
          profileImageUrl = downloadUrl;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildProfileImage() {
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
            radius: 70,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: profileImageUrl.isNotEmpty
                ? NetworkImage(profileImageUrl) as ImageProvider
                : _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage("assets/profile.jpg") as ImageProvider,
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
              onPressed: _pickImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      String label, String value, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          isEditing
              ? TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue.shade800),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Text(
                    value.isNotEmpty ? value : "Not provided",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          "Try Again",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileImage(),
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
                              _buildInfoRow("Full Name", name, nameController),
                              const Divider(height: 24),
                              _buildInfoRow("Student ID", id, idController),
                              const Divider(height: 24),
                              _buildInfoRow("Registration", reg, regController),
                              const Divider(height: 24),
                              _buildInfoRow(
                                  "Session", session, sessionController),
                              const Divider(height: 24),
                              _buildInfoRow("Batch", batch, batchController),
                              const Divider(height: 24),
                              _buildInfoRow("Email", email, emailController),
                              const Divider(height: 24),
                              _buildInfoRow(
                                  "Address", address, addressController),
                              const Divider(height: 24),
                              _buildInfoRow(
                                  "Contact", contactNo, contactController),
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
                                  // Reset controllers
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
                              backgroundColor:
                                  const Color.fromARGB(255, 210, 225, 243),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ), // ✅ Missing parenthesis added here
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

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
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
          _isLoading = false;
        });
      }
    }
  }
}
