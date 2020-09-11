import 'dart:io';
import 'package:archive_your_bill/api/bill_api.dart';
import 'package:image_picker/image_picker.dart';

import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  bool _autovalidate = false;
  // ignore: avoid_init_to_null
  String selectedCategory = null;
  // ignore: avoid_init_to_null
  String selectedCurrency = null;
  String name;

  Bill _currentBill;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime _warrantyValidUntil;
  final itemWarrantyLengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);

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

  Widget _buildShopNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Name of the shop',
          focusColor: Colors.yellow,
          hoverColor: Colors.yellow),
      autovalidate: _autovalidate,
      initialValue: _currentBill.nameShop,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name of the shop is required';
        }

        if (value.length < 2 || value.length > 20) {
          return 'Name must be more than 2 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.nameShop = value;
      },
    );
  }

  Widget _buildItemNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name of the item'),
      autovalidate: _autovalidate,
      initialValue: _currentBill.nameItem,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name of the item is required';
        }

        if (value.length < 2 || value.length > 20) {
          return 'Name must be more than 2 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentBill.nameItem = value;
      },
    );
  }

  Widget _buildItemCategoryField() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      style: TextStyle(fontSize: 16, color: Colors.black),
      hint: Text(
        'Choose category',
      ),
      onChanged: (newValue) => setState(() => _currentBill.category = newValue),
      validator: (value) => value == null ? 'Item category required' : null,
      items: [
        'Electronics',
        'Fashion',
        'Sports',
        'Home',
        'Food',
        'Health',
        'Services',
        'Other'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  //###############################
  //## Cost and currency widgets ##
  //###############################

  Widget _buildCostFieldValue() {
    return TextFormField(
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hoverColor: Colors.black,
        labelText: 'Price',
        labelStyle: TextStyle(fontSize: 16),
        isDense: true,
      ),
      initialValue: _currentBill.nameShop,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentBill.nameShop = value;
      },
    );
  }

  Widget _buildCostCurrencyField() {
    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      decoration: InputDecoration(
        labelText: 'Currency',
        labelStyle: TextStyle(fontSize: 16),
        isDense: true,
      ),
      style: TextStyle(fontSize: 16, color: Colors.black),
      onChanged: (newValue) => setState(() => _currentBill.category = newValue),
      validator: (value) => value == null ? 'Currency required' : null,
      items: [
        'USD',
        'GBP',
        'EUR',
        'PLN',
        'INR',
        'RMB',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildCostField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                //color: Colors.red,
                child: _buildCostFieldValue(),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 1,
              child: Container(
                //color: Colors.blue,
                child: _buildCostCurrencyField(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //######################
  //## Warranty widgets ##
  //######################

  void _presentDatePicker() {
    //Gives future, because we're waiting for user to pick up the date
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void warrantyValidUntil() {
    if (itemWarrantyLengthController.text == '') {
      setState(() {
        _warrantyValidUntil = null;
      });
    } else {
      setState(() {
        _warrantyValidUntil = DateTime(
            _selectedDate.year,
            _selectedDate.month + int.parse(itemWarrantyLengthController.text),
            _selectedDate.day);
      });
    }
    setState(() {
      _warrantyValidUntil = DateTime(
          _selectedDate.year,
          _selectedDate.month + int.parse(itemWarrantyLengthController.text),
          _selectedDate.day);
    });
  }

  Widget _buildItemWarrantyLength() {
    //Data input - ITEM WARRANTY LENGTH
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 16),
              hintText: 'Enter warranty length in months',
              labelText: 'Warranty length'),
          controller: itemWarrantyLengthController,
          onChanged: (_) => warrantyValidUntil(),
          onSubmitted: (_) => warrantyValidUntil(),
        ),
      ),
    );
  }

  Widget _buildChooseStartDayButton() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          children: <Widget>[
            RaisedButton(
              textColor: Theme.of(context).accentColor,
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.orange),
              ),
              child: Text(
                'Choose warranty start date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _presentDatePicker,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: Expanded(
                child: Text(
                  _selectedDate == null
                      ? ''
                      : '${DateFormat.yMMMd().format(_selectedDate)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarrantyValidUntil() {
    //DateTime - WARRANTY VALID UNTIL
    return Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              'Warranty valid until:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              _warrantyValidUntil == null
                  ? ''
                  : '${DateFormat.yMMMd().format(_warrantyValidUntil)}',
            ),
          ),
        ],
      ),
    );
  }

//#########################

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

    uploadBillAndImage(
        _currentBill, widget.isUpdating, _imageFile, _onBillUploaded);

    print("name: ${_currentBill.nameShop}");
    print("category: ${_currentBill.category}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.isUpdating ? "Edit Bill" : "Create Bill",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 16),
              SizedBox(height: 16),
              //if there's no image file
              _imageFile == null && _imageUrl == null
                  ? ButtonTheme(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.orange),
                        ),
                        onPressed: () => _getLocalImage(),
                        child: Text(
                          'Add Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(height: 16),
              SizedBox(height: 26),
              _buildShopNameField(),
              _buildItemNameField(),
              //SizedBox(height: 12),
              _buildItemCategoryField(),
              _buildCostField(),
              _buildItemWarrantyLength(),
              _buildChooseStartDayButton(),
              _buildWarrantyValidUntil(),
            ],
          ),
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
