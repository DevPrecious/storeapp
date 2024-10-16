import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart'; // For getting filename
import 'image_controller.dart'; // Import your image controller

class UploadController extends GetxController {
  final ImageController imageController = Get.find(); // Fetch the image controller instance
  var isLoading = false.obs;

  // Function to send data to the API
  Future<void> uploadData({
    required String title,
    required String category,
    required String subCategory,
    required String price,
    required String brand,
    required String description,
  }) async {
    var uri = Uri.parse('http://172.20.10.4:8000/api/store');
    var request = http.MultipartRequest('POST', uri);

    // Add other form fields
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['sub_category'] = subCategory;
    request.fields['price'] = price;
    request.fields['brand'] = brand;
    request.fields['description'] = description;

    // Set the first non-null image as the main image
    File? mainImage = imageController.images.firstWhere((image) => image != null, orElse: () => null);
    if (mainImage != null) {
      request.fields['main_image'] = basename(mainImage.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'main_image', // Field for the main image
          mainImage.path,
          filename: basename(mainImage.path),
        ),
      );
    }

    // Add all images to the images[] field
    for (int i = 0; i < imageController.images.length; i++) {
      if (imageController.images[i] != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Add all images to this array field
            imageController.images[i]!.path,
            filename: basename(imageController.images[i]!.path),
          ),
        );
      }
    }

    try {
       isLoading.value = true;
      var response = await request.send();

      // Read the response body
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
         isLoading.value = false;
        print("Upload successful!");
        print("Response body: $resBody");
        Get.snackbar('success', 'Yayyyyyy');
        // Handle the successful response
      } else {
        isLoading.value = false;
        print("Upload failed with status code: ${response.statusCode}");
        print("Response body: $resBody");
        // Handle the error based on the response body
      }
    } catch (e) {
      isLoading.value = false;
      print("Error during upload: $e");
      // Handle the exception
    }
  }
}
