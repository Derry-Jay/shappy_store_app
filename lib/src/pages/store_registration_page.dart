import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/controller/user_controller.dart';
import 'package:shappy_store_app/src/elements/BlockButtonWidget.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/shop_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreRegistrationDetailsPage extends StatefulWidget {
  final RouteArgument rar;
  StoreRegistrationDetailsPage(this.rar);
  @override
  _StoreRegistrationDetailsPageState createState() =>
      _StoreRegistrationDetailsPageState();
}

class _StoreRegistrationDetailsPageState
    extends StateMVC<StoreRegistrationDetailsPage> {
  int id;
  PickedFile _image;
  UserController _con;
  StoreCategory shopCategory;
  List<StoreCategory> categories;
  TextEditingController crc = new TextEditingController();
  TextEditingController nrc = new TextEditingController();
  TextEditingController orc = new TextEditingController();
  TextEditingController phrc = new TextEditingController();
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<StoreCategory>>();
  var _currentSelectedValue;

  _StoreRegistrationDetailsPageState() : super(UserController()) {
    _con = controller;
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() => _image = image);
    _con.waitUntilNewShopImageUpload(_image);
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() => _image = image);
    _con.waitUntilNewShopImageUpload(_image);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    categories = widget.rar.param;
    id = int.parse(widget.rar.id);
    print(categories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _con.scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20,
          ),
          child: Form(
            key: _con.loginFormKey,
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5,
                    right: MediaQuery.of(context).size.height / 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Details',
                      style: TextStyle(
                          color: Color(0xffE62337),
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    Text(
                      'Signup to get started and Experience',
                      style: TextStyle(color: Color(0xff474747), fontSize: 12),
                    ),
                    Text(
                      'great Shopping deals',
                      style: TextStyle(color: Color(0xff474747), fontSize: 12),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                  ],
                ),
              ),

              FormField<StoreCategory>(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Select Your Shop Category',
                    ),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StoreCategory>(
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            _currentSelectedValue = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: categories.map((value) {
                          return DropdownMenuItem<StoreCategory>(
                            value: value,
                            child: Text(value.shopCatName),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: MediaQuery.of(context).size.height / 30),
              TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  validator: (input) => input.length < 3
                      ? "Enter the store name, minimum 3 character"
                      : null,
                  onFieldSubmitted: (v) {
                    nrc.text = v;
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: InputDecoration(
                      labelText: "Store Name",
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      contentPadding: EdgeInsets.all(12)),
                  controller: nrc,
                  autofocus: true),
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  validator: (input) => input.length < 3
                      ? "Enter the owner name,minimum 3 character"
                      : null,
                  decoration: InputDecoration(
                      labelText: "Owner Name",
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      contentPadding: EdgeInsets.all(12)),
                  controller: orc,
                  onFieldSubmitted: (v) {
                    orc.text = v;
                    FocusScope.of(context).nextFocus();
                  }),
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 30,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload Photo',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height / 50),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 6.4,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 4,
                      color: Color(0xFFe3e3e3),
                      child: _con.imageLink != null
                          ? Image.network(_con.imageLink)
                          : Icon(Icons.add, size: 40, color: Colors.white),
                    ),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 50)),
              BlockButtonWidget(
                text: Text(
                  "Submit",
                  //#e3e3e3
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  final sharedPrefs = await _sharePrefs;
                  Map<String, dynamic> param = {
                    "shop_ID": widget.rar.id,
                    "cat_ID": _currentSelectedValue.shopCatID.toString(),
                    "shop_name": nrc.text,
                    "owner_name": orc.text,
                    "shop_IMG": _con.imageLink != null ? _con.imageLink : "",
                    "app_type": sharedPrefs.getInt("appType").toString(),
                    "shop_Mobile": sharedPrefs.getString("phone")
                  };
                  print(param);
                  _con.waitUntilRegister(param);
                },
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),
        ),
      ])),
    );
  }
}
