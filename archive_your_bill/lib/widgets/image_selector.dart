import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class ImageSelector{


  Future<File> selectImage() async{
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}