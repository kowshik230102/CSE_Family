import 'package:flutter/material.dart';

class CreatePostSection extends StatefulWidget {
  const CreatePostSection({super.key});

  @override
  _CreatePostSectionState createState() => _CreatePostSectionState();
}

class _CreatePostSectionState extends State<CreatePostSection> {
  String? selectedTag;
  final List<String> tags = [
    "Notice",
    "Result",
    "Achievement",
    "Sports",
    "Others"
  ];
  TextEditingController postController = TextEditingController();
  bool isPostEnabled = false; // Track post button state

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Profile + Input Box
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 16, // Reduced size
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: postController,
                    decoration: InputDecoration(
                      hintText: "Write something...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: TextStyle(fontSize: 14),
                    onChanged: (text) {
                      _updatePostButtonState();
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 6),

            // Row 2: Image, Document, Poll, Tag, Post Button (All in One Line)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icons (Image, Document, Poll) with better spacing
                _buildOptionButton(Icons.image, "Image"),
                _buildOptionButton(Icons.insert_drive_file, "Document"),
                _buildOptionButton(Icons.poll, "Poll"),

                // Tag Dropdown (Compact & No Overflow)
                Container(
                  height: 32, // Same height as button
                  width: 80, // Adjusted width to prevent overflow
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true, // Prevents overflow issue
                      value: selectedTag,
                      hint: Text("Tag", style: TextStyle(fontSize: 12)),
                      items: tags.map((tag) {
                        return DropdownMenuItem<String>(
                          value: tag,
                          child: Text(tag, style: TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTag = value;
                          _updatePostButtonState();
                        });
                      },
                    ),
                  ),
                ),

                // Post Button (Initially White, Turns Green when enabled)
                ElevatedButton(
                  onPressed: isPostEnabled
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Post submitted successfully!")),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPostEnabled ? Colors.green : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: isPostEnabled ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip, // Hover effect to show the name
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade100,
        ),
        child: Icon(icon, size: 18, color: Colors.blue),
      ),
    );
  }

  void _updatePostButtonState() {
    setState(() {
      isPostEnabled = postController.text.isNotEmpty && selectedTag != null;
    });
  }
}
