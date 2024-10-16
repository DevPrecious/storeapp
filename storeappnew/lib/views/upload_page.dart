import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:storeappnew/controller/image_controller.dart';
import 'package:storeappnew/controller/upload_controller.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImageController controller =
      Get.put(ImageController()); // Initialize the controller
  final UploadController uploadcontroller =
      Get.put(UploadController()); // Initialize the controller
  String? _selectedCategory; // To store the selected value
  String? _selectedSubCategory; // To store the selected value
  String? _selectedBrand; // To store the selected value
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () => controller.pickImage(index),
                    child: Obx(() {
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.pink,
                          ),
                        ),
                        child: controller.images[index] != null
                            ? Stack(
                                children: [
                                  Image.file(
                                    controller.images[index]!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      onPressed: () =>
                                          controller.removeImage(index),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Icon(Icons.add),
                              ),
                      );
                    }),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: Text("Category"),
                  value: _selectedCategory,
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue; // Update the selected value
                    });
                  },
                ),
                DropdownButton<String>(
                  hint: Text("Sub Category"),
                  value: _selectedSubCategory,
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSubCategory =
                          newValue; // Update the selected value
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: 'Price',
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text("Brand"),
              value: _selectedBrand,
              items: <String>['Option 1', 'Option 2', 'Option 3']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBrand = newValue; // Update the selected value
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            SizedBox(height: 20),
            GetBuilder<UploadController>(
                init: uploadcontroller,
                builder: (controller) {
                  return controller.isLoading.value ?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
                  ElevatedButton(
                    onPressed: () async {
                      await controller.uploadData(
                        title: titleController.text,
                        category: _selectedCategory ?? '',
                        subCategory: _selectedSubCategory ?? '',
                        price: priceController.text,
                        brand: _selectedBrand ?? '',
                        description: descriptionController.text,
                      );
                    },
                    child: Text('Save'),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
