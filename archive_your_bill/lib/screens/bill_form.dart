import 'dart:io';
import 'package:archive_your_bill/api/bill_api.dart';
import 'package:image_picker/image_picker.dart';

import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//screen to create/edit the bill
class BillForm extends StatefulWidget {
  final bool isUpdating;

  BillForm({@required this.isUpdating});

  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Bill _currentBill;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    BillNotifier billNotifier = Provider.of<BillNotifier>(context, listen: false);

    if (billNotifier.currentBill != null) {
      _currentBill = billNotifier.currentBill;
    } else {
      _currentBill = Bill();
    }
    
    _imageUrl = _currentBill.image;
  }

  _showImage() {
    //if there's any file chosen 
    if (_imageFile == null && _imageUrl == null) {
      return Text(" ");
    //if local file is chosen
    } else if (_imageFile != null) {
      print('showing image from local file');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          //presenting a picture
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          //button to choose a file
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
          )
        ],
      );
    //showing item from url
    } else if (_imageUrl != null) {
      print('showing image from url');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
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
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name of the Shop'),
      initialValue: _currentBill.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 2 || value.length > 20) {
          return 'Name must be more than 2 and less than 20';
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

        if (value.length < 2 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.category = value;
      },
    );
  }

  _buildBillCategoryField() {
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

  _onBillUploaded(Bill bill) {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    billNotifier.addBill(bill);
    Navigator.pop(context);
  }

  _saveBill() {
    print('saveBill Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');
   

    uploadFoodAndImage(
        _currentBill, widget.isUpdating, _imageFile, _onBillUploaded);

    print("name: ${_currentBill.name}");
    print("category: ${_currentBill.category}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Bill Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Bill" : "Create Bill",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _getLocalImage(),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildCategoryField(),
            SizedBox(height: 16),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveBill();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
