import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

//Firebase code
//way of defining an interface classes to implement
//we added abstract class to for example in future
//more easily replace the authentication provider
abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


//generic authorization component that's why we're returning Future
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
    return user.uid;
  }

  //receiving value "user" only when user succesfully login
  Future<String> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

}
