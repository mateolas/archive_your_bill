import 'package:archive_your_bill/model/bill.dart';
import 'package:flutter/material.dart';

class BillForm extends StatefulWidget {
  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  //key to the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _subingredients = [];
  //the same as CurrentBill in BillNotifier
  Bill _currentBill;

  Widget _showImage() {
    return Text('Image Here');
  }

  Widget _buildNameField() {
    return TextFormField(keyboardType: TextInputType.text,
    style: TextStyle(fontSize:20),
    validator: (String value) {
      if(value.isEmpty){
        return 'Name is required';
      }

      if(value.length <3 || value.length > 20){
        return 'Name must be more than 3 and less than 20';
      }

      return null;
    },
    );
  }
  
  Widget _buildCategoryField() {
    return Text('Image Here');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill form'),
      ),
      //to be sure that page will be scrollable
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 16),
              Text(
                'Create Food',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 16),
              ButtonTheme(
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Add Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                _buildNameField(),
                _buildCategoryField(),
                SizedBox(height: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
