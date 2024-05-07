import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageForm extends StatefulWidget {
    final void Function(List<String>)? onImageUploaded; 

   const ImageForm({Key? key, this.onImageUploaded}) : super(key: key);

  @override
  _ImageSelectionFormFieldState createState() => _ImageSelectionFormFieldState();
}

class _ImageSelectionFormFieldState extends State<ImageForm> {
  List<String> _imageUrls = [];

  Future<void> _pickImages(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      List<File> imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      await _uploadImages(imageFiles);
    }
  }
   
  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  void _clearImages() {
    setState(() {
      _imageUrls.clear();
    });
  }

  Future<void> _uploadImages(List<File> imageFiles) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dawfvl61t/upload');

      for (var imageFile in imageFiles) {
        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'gylcvpx1'
          ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          final jsonMap = jsonDecode(responseString);
          
          setState(() {
            final url = jsonMap['url'];
            _imageUrls.add(url);
          });
           widget.onImageUploaded?.call(_imageUrls!); 
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      }

      widget.onImageUploaded?.call(_imageUrls);
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
                    _pickImages(ImageSource.camera);
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImages(ImageSource.gallery);
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
            "Choose images",
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
        SizedBox(height: 15),
        _imageUrls.isNotEmpty
            ? Column(
                children: [
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  _imageUrls[index],
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -19, 
                              left: 40,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red,),
                                onPressed: () {
                                  _removeImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _clearImages();
                    },
                    child: const Text(
                      "Clear All Images",
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