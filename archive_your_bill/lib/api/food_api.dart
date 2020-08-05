import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/model/user.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
