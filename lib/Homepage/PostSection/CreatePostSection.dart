import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File? _documentFile;
  bool _isLoading = false;
  bool _isPostEnabled = false;
  String? _documentFileName;

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
          _documentFile = null; // Clear document if image is selected
          _documentFileName = null;
        });
      }
    } catch (e) {
      _showError("Failed to pick image: ${e.toString()}");
    }
  }

  Future<void> _pickDocument() async {
    try {
      final XFile? file = await _picker.pickMedia();
      if (file != null) {
        setState(() {
          _documentFile = File(file.path);
          _documentFileName = file.name;
          _imageFile = null; // Clear image if document is selected
        });
      }
    } catch (e) {
      _showError("Failed to pick document: ${e.toString()}");
    }
  }

  Future<String?> _uploadFile(File file, String path) async {
    try {
      final ref = _storage
          .ref()
          .child('$path/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      _showError("File upload failed: ${e.toString()}");
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (!_isPostEnabled || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("You must be logged in to post");

      // Get user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception("User data not found");

      final userData = userDoc.data() as Map<String, dynamic>;

      // Upload files if they exist
      String? imageUrl;
      String? documentUrl;

      if (_imageFile != null) {
        imageUrl = await _uploadFile(_imageFile!, 'post_images');
      }

      if (_documentFile != null) {
        documentUrl = await _uploadFile(_documentFile!, 'post_documents');
      }

      // Validate required fields
      if (_selectedTag == null) throw Exception("Please select a tag");
      if (_postController.text.trim().isEmpty) {
        throw Exception("Post content cannot be empty");
      }

      // Create post data
      final postData = {
        'content': _postController.text.trim(),
        'tag': _selectedTag,
        'authorId': user.uid,
        'authorName': userData['name'] ?? user.displayName ?? 'Anonymous',
        'authorAvatar': userData['avatarUrl'] ?? user.photoURL ?? '',
        'imageUrl': imageUrl,
        'documentUrl': documentUrl,
        'documentName': _documentFileName,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
        'edited': false,
      };

      // Add to Firestore
      await _firestore.collection('posts').add(postData);

      // Reset form
      _postController.clear();
      setState(() {
        _selectedTag = null;
        _imageFile = null;
        _documentFile = null;
        _documentFileName = null;
        _isPostEnabled = false;
      });

      // Notify parent widget
      if (widget.onPostCreated != null) {
        widget.onPostCreated!();
      }

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

  @override
  Widget build(BuildContext context) {
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

              // Post Content Field
              TextField(
                controller: _postController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),

              // Tag Selection
              DropdownButtonFormField<String>(
                value: _selectedTag,
                decoration: InputDecoration(
                  labelText: "Select a tag",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: _tags.map((tag) {
                  return DropdownMenuItem<String>(
                    value: tag,
                    child: Text(tag),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTag = value;
                    _updatePostButtonState();
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select a tag';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image Preview
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

              // Document Preview
              if (_documentFile != null)
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.insert_drive_file),
                      title: Text(_documentFileName ?? 'Document'),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() {
                          _documentFile = null;
                          _documentFileName = null;
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Action Buttons
              Row(
                children: [
                  // Add Image Button
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.blue),
                    onPressed: _pickImage,
                    tooltip: 'Add Image',
                  ),
                  const SizedBox(width: 8),
                  Text("Add Image", style: TextStyle(color: Colors.blue)),

                  // Add Document Button
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.blue),
                    onPressed: _pickDocument,
                    tooltip: 'Add Document',
                  ),
                  const SizedBox(width: 8),
                  Text("Add File", style: TextStyle(color: Colors.blue)),

                  const Spacer(),

                  // Post Button
                  ElevatedButton(
                    onPressed:
                        _isPostEnabled && !_isLoading ? _submitPost : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
