import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shappy_store_app/src/controller/shop_data_controller.dart';
import 'package:shappy_store_app/src/models/shop_category.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:shappy_store_app/src/elements/BlockButtonWidget.dart';
import 'package:shappy_store_app/src/models/store.dart';

class StoreDetailsPage extends StatefulWidget {
  final RouteArgument rar;
  StoreDetailsPage(this.rar);
  @override
  State<StatefulWidget> createState() => StoreDetailPageState();
}

class StoreDetailPageState extends StateMVC<StoreDetailsPage> {
  Store store;
  PickedFile _image;
  StoreDataController _con;
  StoreCategory shopCategory;
  List<StoreCategory> categories;
  TextEditingController crc = new TextEditingController();
  TextEditingController nrc = new TextEditingController();
  TextEditingController orc = new TextEditingController();
  TextEditingController phrc = new TextEditingController();
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<StoreCategory>>();

  StoreDetailPageState() : super(StoreDataController()) {
    _con = controller;
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() => _image = image);
    _con.waitUntilShopImageUpload(_image);
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() => _image = image);
    _con.waitUntilShopImageUpload(_image);
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
    store = widget.rar.param["shop"];
    categories = widget.rar.param["categories"];
    crc.text = store.storeCat != null ? store.storeCat : "";
    nrc.text = store.storeName != null ? store.storeName : "";
    orc.text = store.ownerName != null ? store.ownerName : "";
    phrc.text = store.shopMob != null ? store.shopMob : "";
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
              AutoCompleteTextField<StoreCategory>(
                  style: TextStyle(color: Colors.black),
                  controller: crc,
                  textInputAction: TextInputAction.next,
                  clearOnSubmit: false,
                  key: key,
                  suggestions: categories,
                  itemSorter: (a, b) => a.shopCatName.compareTo(b.shopCatName),
                  itemSubmitted: (item) {
                    crc.text = item.shopCatName;
                    shopCategory = item;
                    return shopCategory;
                  },
                  itemBuilder: (context, category) => new Padding(
                      child: new ListTile(
                          title: new Text(category.shopCatName),
                          trailing: new Text(category.shopCatID.toString())),
                      padding: EdgeInsets.all(8.0)),
                  itemFilter: (category, input) => category.shopCatName
                      .toLowerCase()
                      .startsWith(input.toLowerCase()),
                  suggestionsAmount: categories.length,
                  decoration: InputDecoration(
                      labelText: "Store Category",
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.all(12))),
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
                      labelStyle: TextStyle(color: Colors.grey),
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
                      labelStyle: TextStyle(color: Colors.grey),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      child: store.imageURL != null
                          ? ClipRect(
                              child: Image.network(
                                store.imageURL,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Icon(Icons.add, size: 40, color: Colors.white),
                    ),
                    onTap: () {
                      print("Click event on Container");
                      _showPicker(context);
                    },
                  ),
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 50)),
              BlockButtonWidget(
                text: Text(
                  "Save",
                  //#e3e3e3
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  int id;
                  for (StoreCategory cat in categories)
                    if ((crc.text != null
                            ? crc.text
                            : (store.storeCat != null ? store.storeCat : "")) ==
                        cat.shopCatName) id = cat.shopCatID;
                  Map<String, dynamic> param = {
                    "shop_ID": store.storeID.toString(),
                    "cat_ID": shopCategory != null
                        ? shopCategory.shopCatID.toString()
                        : id.toString(),
                    "shop_name": nrc.text,
                    "owner_name": orc.text,
                    "shop_IMG": _con.imageLink != null
                        ? _con.imageLink
                        : (store.imageURL != null ? store.imageURL : "")
                  };
                  _con.updateStoreDetail(param);
                },
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),
        ),
      ])),
    );
  }
}
