import 'package:archive_your_bill/services/bills_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import './screens/rootScreen.dart';
import 'package:archive_your_bill/widgets/auth.dart';


//to use get_it library we need to initialize it in main method
void setupLocator(){
  //it's stating instance available everywhere in the app
  //singleton means that there could be only one instance of an object
  //I - shortcut for instance
  //we don't need more than one instance of a Bills service
  GetIt.I.registerLazySingleton(() => BillsService());
  //consuming the singleton
  //return an instance of BillsService GetIt.instance<BillsService>();
}

void main() {
  setupLocator();
  runApp(MyApp());
}

//class which is the main widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        accentColor: Colors.black,
        hintColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      title: 'Archive your bill',
      home: RootScreen(
        auth: Auth(),
      ),
    );
  }
}

