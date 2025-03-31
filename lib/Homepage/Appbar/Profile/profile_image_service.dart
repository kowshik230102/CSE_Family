import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageService {
  final ImagePicker picker = ImagePicker();

  /// Picks an image from the gallery
  Future<File?> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  /// Uploads an image to Firebase Storage
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  /// Deletes an image from Firebase Storage
  Future<void> deleteImage(String userId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
      await storageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: ${e.toString()}');
    }
  }
}
