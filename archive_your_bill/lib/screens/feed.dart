import 'package:archive_your_bill/api/food_api.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  const Feed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    print("building Feed");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //showing the 'Display name' at the top of the screen
          authNotifier.user != null ? authNotifier.user.displayName : "Feed",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Feed",
          style: TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
