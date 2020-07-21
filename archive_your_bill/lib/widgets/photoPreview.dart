import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import 'dart:io';
import 'dart:async';

class PhotoPreview extends StatefulWidget {
  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  File imageFile;
  final picker = ImagePicker();


  void _openGallery(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile, width: 200, height: 200);
    } else {
      return Text("Please select an image");
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        //_openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _setImageView(),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              _showSelectionDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
