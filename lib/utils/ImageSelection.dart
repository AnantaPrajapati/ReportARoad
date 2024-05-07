import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageSelectionFormField extends StatefulWidget {
  final ValueChanged<String>? onImageUploaded;

  const ImageSelectionFormField({Key? key, this.onImageUploaded}) : super(key: key);

  @override
  _ImageSelectionFormFieldState createState() => _ImageSelectionFormFieldState();
}

class _ImageSelectionFormFieldState extends State<ImageSelectionFormField> {
  String? _imageUrl;
  File? _imageFile;

    void _clearImage() {
    setState(() {
      _imageUrl = null;
      _imageFile = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage(_imageFile!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dawfvl61t/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'gylcvpx1'
        ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        setState(() {
          final url = jsonMap['url'];
          _imageUrl = url;
        });
        widget.onImageUploaded?.call(_imageUrl!); 
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

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
                    _pickImage(ImageSource.camera);
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        _imageUrl != null
            ? Column(
                children: [
                  Image.network(
                    _imageUrl!,
                    height: 200,
                    width: 200,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _clearImage(); 
                    },
                    child: const Text(
                      "Clear Image",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, 
                      onPrimary: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              )
            : SizedBox(height: 0),
      ],
    );
  }
}