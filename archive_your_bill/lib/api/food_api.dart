import 'dart:io';

import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/model/user.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

//Class to communicate with the Firebase API

//passing user and notifier to user
//login user to Firebase
login(User user, AuthNotifier authNotifier) async {
  //that's how we're access authentication method
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      //feature of Firebase
      .catchError((error) => print(error.code));

  //checking the result of login
  if (authResult != null) {
    //if not empty, we can assign it to firebease user
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      //if user is not empty we can set user (using notifier)
      //provider informts different parts of the app that user has changed
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

//creating user
signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  //checking the results of the signing
  //during signup we want to get also a "Display name"
  if (authResult != null) {
    //part of the Firebase user classes
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      //updating/refreshing the user profile
      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      //refetch the current user after reloading
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  //not returning anything
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

//get the current user from Firebase when we're already signed in
initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    //notify app
    authNotifier.setUser(firebaseUser);
  }
}

//method to get Bills
//when we call it we get bills from firebase
//whoever is listetning to that gets notified
getBills(BillNotifier billNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('Bills').getDocuments();

  List<Bill> _billList = [];

  snapshot.documents.forEach((document) {
    //creating new bill object
    //fromMap - constructor which we created
    Bill bill = Bill.fromMap(document.data);
    _billList.add(bill);
  });

  //notifing that we have a new bill list
  billNotifier.billList = _billList;
}

//uploading bills to our API
//added second parametere to know, are we adding new Bill
//or we're updating existing one
//uploading our image first
//if that was ok than we get an url from the image
//than we call upload bill
//than we get documentref
//then we update the Bill object with new ID
uploadBillandImage(Bill bill, bool isUpdating, File localFile) async {
  if (localFile != null) {
    print('uploading image');

    //getting the extension of file //jpg, gif, etc.
    var fileExtension = path.extension(localFile.path);

    //creating an unique user ID
    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        //uuid name of the picture file
        //reference to the file at that location
        FirebaseStorage.instance
            .ref()
            .child('archive/images/$uuid$fileExtension');

    //thanks to it we're uploaded a file
    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    _uploadBill(bill, isUpdating, imageUrl: url);
    print("download url: $url");
  } else {
    print('...skipping image upload');
    _uploadBill(bill, isUpdating);
  }
}

_uploadBill(Bill bill, bool isUpdating, {String imageUrl}) async {
  //reference to our Bill object
  CollectionReference billRef = await Firestore.instance.collection('Bills');

  if (imageUrl != null) {
    bill.image = imageUrl;
  }

  if (isUpdating) {
    bill.updatedAt = Timestamp.now();
    //updated proper Bill with proper id with our Bill converted as a Map
    await billRef.document(bill.id).updateData(bill.toMap());
    print('updated bill with id: ${bill.id}');
  } else {
    bill.createdAt = Timestamp.now();

    DocumentReference documentRef = await billRef.add(bill.toMap());

    //local id
    bill.id = documentRef.documentID;
    print('uploaded food successfully: ${bill.toString()}');

    //uploading local id to server
    //merge - we just want to add new data to object
    await documentRef.setData(bill.toMap(), merge: true);
  }
}
