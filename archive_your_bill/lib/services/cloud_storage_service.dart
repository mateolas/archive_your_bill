import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/cloud_storage_result.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,

  }) async{
    //name of the file in cloud storage
    var imageFileName = title + DateTime.now().millisecondsSinceEpoch.toString(); 
    //Get the reference to the file we want to create
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(imageFileName); 
    //store the result on the firebase reference
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    //allow to get information from the file which was uploaded
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    //
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if(uploadTask.isComplete){
      var url = downloadUrl.toString();
      return CloudStorageResult(imageUrl: url,
      imageFileName: imageFileName
      );
    }
     return null;
  }
}