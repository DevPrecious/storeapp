import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageController extends GetxController {
  final picker = ImagePicker();
  var images = List<File?>.filled(3, null).obs; // For 3 image spots

  // Function to pick an image from the gallery for a specific spot
  Future<void> pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      images[index] = File(pickedFile.path);
    }
  }

  // Function to remove an image from a specific spot
  void removeImage(int index) {
    images[index] = null; // Remove image
  }
}
