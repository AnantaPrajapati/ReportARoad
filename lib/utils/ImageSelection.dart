import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectionFormField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onImageSelected;

  const ImageSelectionFormField({
    Key? key,
    required this.controller,
    this.onImageSelected,
  }) : super(key: key);

  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImageFromCamera(context);
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImageFromGallery(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImageFromCamera(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      controller.text = image.path;
      if (onImageSelected != null) {
        onImageSelected!();
      }
    }
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.text = image.path;
      if (onImageSelected != null) {
        onImageSelected!();
      }
    }
  }

 @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text(
                "Choose an image",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2C75FF),
                onPrimary: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _showImagePickerDialog(context);
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Image Path',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
