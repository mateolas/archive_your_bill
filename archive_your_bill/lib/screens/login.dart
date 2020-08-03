import 'package:archive_your_bill/api/food_api.dart';
import 'package:archive_your_bill/model/user.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//define Signup and Login states
enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //passwordController to get the password
  final TextEditingController _passwordController = new TextEditingController();
  //setting authMode to Login as default
  AuthMode _authMode = AuthMode.Login;
  User _user = User();

  @override
  void initState() {
    //getting the provider object
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    //if we're already loged in, when we first lunch the app
    //than we call this method and fed that firebase to authNotifier
    //which will trigger the Consumer and check the condition from Home page (Feed or Login page)
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  //to validate and save form
  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    //if we have a valid form then ...
    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Display Name"),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 26),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Display Name is required';
        }

        if (value.length < 5 || value.length > 12) {
          return 'Display Name must be betweem 5 and 12 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _user.displayName = value;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      initialValue: 'julian@food.com',
      style: TextStyle(fontSize: 26),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password"),
      style: TextStyle(fontSize: 26),
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 5 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _user.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Confirm Password"),
      style: TextStyle(fontSize: 26),
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building login screen");

    return Scaffold(
      body: Form(
        autovalidate: true,
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
            child: Column(
              children: <Widget>[
                Text(
                  "Please Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36),
                ),
                SizedBox(height: 32),
                _authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                _buildEmailField(),
                _buildPasswordField(),
                _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
                SizedBox(height: 32),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  //text on the upper button
                  //changing between login and signup mode
                  child: Text(
                    'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //switched the modes itself.
                    setState(() {
                      _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                    });
                  },
                ),
                SizedBox(height: 16),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () => _submitForm(),
                  child: Text(
                    //text on the lower button
                    _authMode == AuthMode.Login ? 'Login' : 'Signup',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
