import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Appbar/my_account_page.dart'; // Ensure this path is correct

class CreatePostSection extends StatefulWidget {
  final Function()? onPostCreated;
  const CreatePostSection({super.key, this.onPostCreated});

  @override
  State<CreatePostSection> createState() => _CreatePostSectionState();
}

class _CreatePostSectionState extends State<CreatePostSection> {
  final TextEditingController _postController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String? _selectedTag;
  File? _imageFile;
  bool _isLoading = false;
  bool _isPostEnabled = false;
  String _userFirstName = 'User';

  final List<String> _tags = [
    "Notice",
    "Result",
    "Achievement",
    "Sports",
    "Others"
  ];

  @override
  void initState() {
    super.initState();
    _postController.addListener(_updatePostButtonState);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final fullName = userData['name'] ?? user.displayName ?? 'User';
          setState(() {
            _userFirstName = fullName.split(' ').first;
          });
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _updatePostButtonState() {
    setState(() {
      _isPostEnabled =
          _postController.text.trim().isNotEmpty && _selectedTag != null;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      _showError("Failed to pick image: ${e.toString()}");
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      final ref = _storage
          .ref()
          .child('post_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = ref.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      _showError("Image upload failed: ${e.toString()}");
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (!_isPostEnabled || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("You must be logged in to post");

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception("User data not found");

      final userData = userDoc.data() as Map<String, dynamic>;
      final imageUrl = await _uploadImage();

      if (_selectedTag == null) throw Exception("Please select a tag");
      if (_postController.text.trim().isEmpty)
        throw Exception("Post content cannot be empty");

      final postData = {
        'content': _postController.text.trim(),
        'tag': _selectedTag,
        'authorId': user.uid,
        'authorName': userData['name'] ?? user.displayName ?? 'Anonymous',
        'authorAvatar': userData['avatarUrl'] ?? user.photoURL ?? '',
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
        'edited': false,
      };

      await _firestore.collection('posts').add(postData);

      _postController.clear();
      setState(() {
        _selectedTag = null;
        _imageFile = null;
        _isPostEnabled = false;
      });

      widget.onPostCreated?.call();
      _showSuccess("Post created successfully!");
    } on FirebaseException catch (e) {
      _showError("Firebase error: ${e.message}");
    } catch (e) {
      _showError("Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToProfile() {
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyAccountPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _auth.currentUser;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Post",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _navigateToProfile,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade100,
                            image: user?.photoURL != null
                                ? DecorationImage(
                                    image: NetworkImage(user!.photoURL!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: user?.photoURL == null
                              ? Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userFirstName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _postController,
                          maxLines: 5,
                          minLines: 3,
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: theme.cardTheme.color,
                            hintStyle: TextStyle(color: theme.hintColor),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedTag,
                          decoration: InputDecoration(
                            labelText: "Select a tag",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: theme.cardTheme.color,
                            labelStyle: TextStyle(
                                color: theme.textTheme.bodyLarge?.color),
                          ),
                          dropdownColor: theme.cardTheme.color,
                          items: _tags.map((tag) {
                            return DropdownMenuItem<String>(
                              value: tag,
                              child: Text(tag,
                                  style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTag = value;
                              _updatePostButtonState();
                            });
                          },
                          style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_imageFile != null)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _imageFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => setState(() => _imageFile = null),
                      child: Text("Remove Image"),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.blue),
                    onPressed: _pickImage,
                    tooltip: 'Add Image',
                  ),
                  const SizedBox(width: 8),
                  Text("Add Image", style: TextStyle(color: Colors.blue)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed:
                        _isPostEnabled && !_isLoading ? _submitPost : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Post",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
