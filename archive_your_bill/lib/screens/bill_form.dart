import 'dart:io';
import 'package:archive_your_bill/api/food_api.dart';
import 'package:image_picker/image_picker.dart';

import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillForm extends StatefulWidget {
//adding boolean to know, are we creating or editing the bill
  final bool isUpdating;

  BillForm({@required this.isUpdating});

  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  //key to the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _subingredients = [];
  //the same as CurrentBill in BillNotifier
  Bill _currentBill;
  //if we're having an image we will modify it
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  //getting current bill from bill notifier
  //initState is build even before the widget tree is built
  @override
  void initState() {
    super.initState();
    //listen: false because we only want to get data, not listen to it
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);

    //checking if we're editing or adding new Bill
    //referring to the the 'AddButtion' at the feed page
    if (billNotifier.currentBill != null) {
      _currentBill = billNotifier.currentBill;
    } else {
      _currentBill = Bill();
    }

    //_subingredients.addAll(_currentBill.subIngredients);
    _imageUrl = _currentBill.image;
  }

  //this function will show the image if we have it
  Widget _showImage() {
    //if we don't have a local file or the image from the web
    if (_imageFile == null && _imageUrl == null) {
      return Text('image placeholder');
    }
    //we always want to execute the_imageFile condition
    //even when the imageUrl exists
    //it means we want to upload new picture for the bill
    else if (_imageFile != null) {
      print('showing image from local file');
      //thanks to Stack we're returning a local image using ImagePicker
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          //getting local image
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          ),
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');
      //Stack allowys to put two images on top of each other
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          ),
        ],
      );
    }
  }

  //it will be an asynchronous operation so function async
  _getLocalImage() async {
    //adding new file

    //here we're getting the image
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400,
    );

    //now we're setting the state of the image
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      //the case if we're editing the bill
      initialValue: _currentBill.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentBill.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.category = value;
      },
    );
  }

  _buildSubingredientField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: subingredientController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Subingredient'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _addSubingredient(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subingredients.add(text);
      });
      subingredientController.clear();
    }
  }


saveBill(){
  //if the form isn't valid
  if(!_formKey.currentState.validate()){
    return;
  }

  _formKey.currentState.save();

  //adding subingredients to local list
  _currentBill.subIngredients = _subingredients;

  uploadBillandImage(_currentBill, widget.isUpdating,_imageFile );

  print("name: ${_currentBill.name}");
  print("category: ${_currentBill.category}");
  print("subIngredients: ${_currentBill.subIngredients.toString()}");
  print("_imageFile: ${_imageFile.toString()}"); 
  print("_imageUrl ${_imageUrl}");


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
                widget.isUpdating ? 'Edit Food' : 'Create Bill',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 16),
              //if we don't have an image file we're not showing the button
              _imageFile == null && _imageUrl == null
                  ? ButtonTheme(
                      child: RaisedButton(
                        //the same function for 2 buttons
                        onPressed: () => _getLocalImage(),
                        child: Text(
                          'Add Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              _buildNameField(),
              _buildCategoryField(),
              //Setting the ingredients
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildSubingredientField(),
                  ButtonTheme(
                    child: RaisedButton(
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                      onPressed: () =>
                          _addSubingredient(subingredientController.text),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8),
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                children: _subingredients
                    .map((ingredient) => Card(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              ingredient,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveBill(),
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
