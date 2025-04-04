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
  bool _showPollOptions = false;
  final List<String> _pollOptions = ['', ''];
  String _postType = 'post'; // 'post', 'poll', or 'document'

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
      _isPostEnabled = _postController.text.trim().isNotEmpty &&
          (_selectedTag != null || _postType == 'poll') &&
          !(_postType == 'poll' &&
              _pollOptions.any((option) => option.isEmpty));
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _postType = 'post';
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
          _postType = 'document';
        });
      }
    } catch (e) {
      _showError("Failed to pick document: ${e.toString()}");
    }
  }

  Future<String?> _uploadFile(File? file, String path) async {
    if (file == null) return null;

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

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception("User data not found");

      final userData = userDoc.data() as Map<String, dynamic>;
      final imageUrl = await _uploadFile(_imageFile, 'post_images');
      final documentUrl = await _uploadFile(_documentFile, 'post_documents');

      if (_postType == 'post' && _selectedTag == null) {
        throw Exception("Please select a tag");
      }
      if (_postController.text.trim().isEmpty) {
        throw Exception("Post content cannot be empty");
      }
      if (_postType == 'poll' && _pollOptions.any((option) => option.isEmpty)) {
        throw Exception("Poll options cannot be empty");
      }

      final postData = {
        'content': _postController.text.trim(),
        'tag': _selectedTag,
        'authorId': user.uid,
        'authorName': userData['name'] ?? user.displayName ?? 'Anonymous',
        'authorAvatar': userData['avatarUrl'] ?? user.photoURL ?? '',
        'imageUrl': imageUrl,
        'documentUrl': documentUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
        'edited': false,
        'type': _postType,
        if (_postType == 'poll') 'pollOptions': _pollOptions,
        if (_postType == 'poll')
          'pollVotes': List.filled(_pollOptions.length, 0),
      };

      await _firestore.collection('posts').add(postData);

      _postController.clear();
      setState(() {
        _selectedTag = null;
        _imageFile = null;
        _documentFile = null;
        _isPostEnabled = false;
        _showPollOptions = false;
        _pollOptions.fillRange(0, 2, '');
        _postType = 'post';
      });

      widget.onPostCreated?.call();
      _showSuccess("Post created successfully!");
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

  void _showProfileDetails() {
    final user = _auth.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Profile Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoURL ?? ''),
              ),
            ),
            SizedBox(height: 16),
            Text("Name: ${user.displayName ?? 'Anonymous'}"),
            Text("Email: ${user.email ?? 'Not provided'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
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
                  color: Colors.blue, // Changed to blue
                ),
              ),
              const SizedBox(height: 16),

              // User profile and input row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile circle
                  GestureDetector(
                    onTap: _showProfileDetails,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? Icon(Icons.person, size: 24)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Post content and tag
                  Expanded(
                    child: Column(
                      children: [
                        // Post Content Field
                        TextField(
                          controller: _postController,
                          maxLines: 8, // Increased height
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

                        // Tag Selection
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

              // Post type selector
              Row(
                children: [
                  _buildPostTypeButton(Icons.image, "Photo", 'post',
                      isActive: _postType == 'post'),
                  const SizedBox(width: 8),
                  _buildPostTypeButton(Icons.poll, "Poll", 'poll',
                      isActive: _postType == 'poll'),
                  const SizedBox(width: 8),
                  _buildPostTypeButton(
                      Icons.insert_drive_file, "Document", 'document',
                      isActive: _postType == 'document'),
                ],
              ),
              const SizedBox(height: 16),

              // Poll options (if poll selected)
              if (_postType == 'poll')
                Column(
                  children: [
                    ..._pollOptions.asMap().entries.map((entry) {
                      final index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Option ${index + 1}",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _pollOptions[index] = value;
                            _updatePostButtonState();
                          },
                        ),
                      );
                    }).toList(),
                    if (_pollOptions.length < 4)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _pollOptions.add('');
                          });
                        },
                        child: Text("Add Option"),
                      ),
                  ],
                ),

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
                      title: Text(_documentFile!.path.split('/').last),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() => _documentFile = null),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Post Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isPostEnabled && !_isLoading ? _submitPost : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Changed to blue
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostTypeButton(IconData icon, String label, String type,
      {required bool isActive}) {
    return Expanded(
      child: OutlinedButton.icon(
        icon: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
        label: Text(label,
            style: TextStyle(color: isActive ? Colors.blue : Colors.grey)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isActive ? Colors.blue : Colors.grey),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          setState(() {
            _postType = type;
            if (type == 'poll') {
              _selectedTag = null;
            }
            _updatePostButtonState();
          });
        },
      ),
    );
  }
}
