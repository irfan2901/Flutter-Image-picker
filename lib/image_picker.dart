import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  ImagePickerExampleState createState() => ImagePickerExampleState();
}

class ImagePickerExampleState extends State<ImagePickerExample> {
  List<File> _pickedImages = [];
  File? _singlePickedImage;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _pickedImages =
          pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
  }

  Future<void> _pickSingleImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _singlePickedImage = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: const Text('Pick Multiple Images'),
          ),
          const SizedBox(height: 16),
          _pickedImages.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pickedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _pickedImages[index],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.red,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickSingleImage,
            child: const Text('Pick Single Image'),
          ),
          _singlePickedImage != null
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        _singlePickedImage!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _removeSingleImage(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: Colors.red,
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  void _removeSingleImage() {
    setState(() {
      _singlePickedImage = null;
    });
  }
}
