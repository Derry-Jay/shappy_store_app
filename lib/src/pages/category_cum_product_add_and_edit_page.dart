import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:shappy_store_app/src/controller/product_category_and_product_controller.dart';

class AddOrEditProductAndCategoryPage extends StatefulWidget {
  final aoeFlag, pocFlag;
  final ProductCategory category;
  final Product product;
  final List<ProductCategory> categories;
  final List<MeasurementUnit> units;
  AddOrEditProductAndCategoryPage(this.aoeFlag, this.pocFlag, this.category,
      this.product, this.categories, this.units);
  @override
  State<StatefulWidget> createState() => AddOrEditProductAndCategoryPageState(
      this.aoeFlag, this.pocFlag, this.category, this.categories);
}

class AddOrEditProductAndCategoryPageState
    extends StateMVC<AddOrEditProductAndCategoryPage> {
  String title;
  PickedFile _image;
  final aoeFlag, pocFlag;
  ProductCategory category;
  List<MeasurementUnit> units;
  MeasurementUnit u1, u2, unit;
  CategoryAndProductController _con;
  final List<ProductCategory> categories;
  List<DropdownMenuItem<MeasurementUnit>> dropDownList;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<ProductCategory>>();
  TextEditingController crc = new TextEditingController();
  TextEditingController prc = new TextEditingController();
  TextEditingController pdrc = new TextEditingController();
  TextEditingController prrc = new TextEditingController();
  TextEditingController wtrc = new TextEditingController();
  TextEditingController utrc = new TextEditingController();
  AddOrEditProductAndCategoryPageState(
      this.aoeFlag, this.pocFlag, this.category, this.categories)
      : super(CategoryAndProductController()) {
    _con = controller;
    if (_con.imageUrl != null) _image = new PickedFile(_con.imageUrl);
  }
  var _currentSelectedValue;
  @override
  void initState() {
    title = aoeFlag == 'a' ? "Add" : (aoeFlag == 'e' ? "Edit" : "");
    title += " ";
    title += pocFlag == 'c' ? "Category" : (pocFlag == 'p' ? "Product" : "");
    crc.text = category != null
        ? category.proCat
        : (widget.product != null ? widget.product.proCat : "");
    if (pocFlag == 'p') {
      prc.text = widget.product != null ? widget.product.name : "";
      pdrc.text = widget.product != null ? widget.product.description : "";
      prrc.text = widget.product != null ? widget.product.price.toString() : "";
      wtrc.text =
          widget.product != null ? widget.product.weight.toString() : "";
      if (widget.product != null)
        for (MeasurementUnit ut in widget.units)
          if (ut == widget.product.unit) {
            u1 = ut;
            break;
          }
      u2 = widget.units[0];
      unit = u1 ?? u2;
      dropDownList = getDropDownItems(widget.units);
    }
    super.initState();
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
      _con.waitUntilProductImageUpload(_image);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      _con.waitUntilProductImageUpload(_image);
    });
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
                      title: new Text('Photo Library',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera',
                        style: TextStyle(color: Colors.black)),
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

  changeUnit(MeasurementUnit ut) {
    setState(() => unit = ut);
  }

  List<DropdownMenuItem<MeasurementUnit>> getDropDownItems(
      List<MeasurementUnit> ul) {
    List<DropdownMenuItem<MeasurementUnit>> items = List();
    for (MeasurementUnit favouriteFoodModel in ul) {
      items.add(DropdownMenuItem(
        value: favouriteFoodModel,
        child: Text(favouriteFoodModel.unit),
      ));
    }
    return items;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f2f2),
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                child: Column(children: [
                  Text("Add an Image",
                      style: TextStyle(color: Colors.black, fontSize: 17)),
                  SizedBox(
                    height: 10,
                  ),
                  (_image == null || _image.path == "") &&
                          (widget.product == null ||
                              widget.product.image == null ||
                              widget.product.image == "")
                      ? FlatButton(
                          onPressed: () => _showPicker(context),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.black26,
                          ))
                      : ClipRect(
                          child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: _con.imageUrl == null
                                            ? (widget.product.image == null ||
                                                    widget.product.image == ""
                                                ? AssetImage(
                                                    "assets/img/loading.gif")
                                                : NetworkImage(
                                                    widget.product.image))
                                            : NetworkImage(_con.imageUrl),
                                        fit: BoxFit.contain)),
                                height: 75,
                                alignment: Alignment(-10.0, 0.0),
                              ),
                              onTap: () => _showPicker(context)),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                ]),
                visible: pocFlag == 'p'),
            Text(
              "Category",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            SizedBox(
              height: 10,
            ),
            pocFlag == 'c'
                ? TextField(
                    controller: crc,
                    onSubmitted: (val) => setState(() => crc.text = val),
                    onEditingComplete: () => setState(() {}),
                    // onTap: ()=>setState((){}),
                  )
                : (pocFlag == 'p'
                    ? FormField<ProductCategory>(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.0),
                              hintText: 'Select Your Product Category',
                            ),
                            isEmpty: _currentSelectedValue == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<ProductCategory>(
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    _currentSelectedValue = newValue;
                                    category = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: categories.map((value) {
                                  return DropdownMenuItem<ProductCategory>(
                                    value: value,
                                    child: Text(value.proCat),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(height: 0, width: 0)),
            // AutoCompleteTextField<ProductCategory>(
            //   controller: crc,
            //   textInputAction: TextInputAction.next,
            //   clearOnSubmit: false,
            //   key: key,
            //   suggestions: categories,
            //   itemSorter: (a, b) => a.proCat.compareTo(b.proCat),
            //   itemSubmitted: (item) {
            //     crc.text = item.proCat;
            //     category = item;
            //     return category;
            //   },
            //   itemBuilder: (context, category) => new Padding(
            //       child: new ListTile(
            //           title: new Text(category.proCat),
            //           trailing: new Text(category.shopID.toString())),
            //       padding: EdgeInsets.all(8.0)),
            //   itemFilter: (category, input) =>
            //       category.proCat.toLowerCase().startsWith(input.toLowerCase()),
            // ),
            SizedBox(
              height: 30,
            ),
            Visibility(
                visible: pocFlag == 'p',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product",
                        style: TextStyle(color: Colors.black, fontSize: 17)),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: prc,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (val) => prc.text = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Product Description",
                        style: TextStyle(color: Colors.black, fontSize: 17)),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: pdrc,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (val) => pdrc.text = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Price",
                        style: TextStyle(color: Colors.black, fontSize: 17)),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: prrc,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSubmitted: (val) => prrc.text = val,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Net Weight",
                        style: TextStyle(color: Colors.black, fontSize: 17)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Expanded(
                          child: TextField(
                        controller: wtrc,
                        keyboardType: TextInputType.number,
                        onSubmitted: (val) => wtrc.text = val,
                      )),
                      Expanded(
                          child: DropdownButton<MeasurementUnit>(
                        value: unit,
                        icon: Icon(Icons.arrow_downward,
                            color: Color(0xffe62136)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        onChanged: changeUnit,
                        items: widget.units
                            .map<DropdownMenuItem<MeasurementUnit>>((value) {
                          return DropdownMenuItem<MeasurementUnit>(
                            value: value,
                            child: Text(value.unit),
                          );
                        }).toList(),
                      ))
                    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                  ],
                )),
            RaisedButton(
                onPressed: () async {
                  final SharedPreferences sharedPrefs = await _sharePrefs;
                  if (aoeFlag == 'a' && pocFlag == 'p') {
                    Map<String, dynamic> param = {
                      "shop_ID": sharedPrefs.getString("spShopID"),
                      "product_name": prc.text,
                      "productCat_ID":
                          category == null ? "" : category.proCatID.toString(),
                      "UOM_ID": unit.id.toString(),
                      "product_description": pdrc.text,
                      "price": prrc.text,
                      "weight": wtrc.text,
                      "Product_IMG":
                          _con.imageUrl == "" || _con.imageUrl == null
                              ? ""
                              : _con.imageUrl
                    };
                    _con.waitUntilAddProduct(body: param);
                  } else if (aoeFlag == 'e' && pocFlag == 'p') {
                    Map<String, dynamic> uploadParam = {
                      "shop_ID": sharedPrefs.getString("spShopID"),
                      "product_ID": widget.product.proID.toString(),
                      "productCat_ID": category.proCatID.toString(),
                      "product_name": prc.text,
                      "product_description": pdrc.text,
                      "price": prrc.text,
                      "weight": wtrc.text,
                      "Product_IMG":
                          _con.imageUrl == "" || _con.imageUrl == null
                              ? (widget.product.image != null
                                  ? widget.product.image
                                  : "")
                              : _con.imageUrl,
                      "UOM_ID": unit.id.toString()
                    };
                    _con.waitUntilEditProduct(body: uploadParam);
                  } else if (aoeFlag == 'a' && pocFlag == 'c') {
                    _con.waitUntilAddCategory(
                        shopID: sharedPrefs.getString("spShopID"),
                        proCat: crc.text);
                  } else if (aoeFlag == 'e' && pocFlag == 'c') {
                    _con.waitUntilEditCategory(
                        shopID: sharedPrefs.getString("spShopID"),
                        proCat: crc.text,
                        proCatID: category.proCatID.toString());
                  }
                },
                child: Text(
                  aoeFlag == 'a' ? "Add" : (aoeFlag == 'e' ? "Update" : ""),
                  style: TextStyle(color: Colors.white),
                ),
                color: Color(0xffe62136))
          ],
        ),
      ),
    );
  }
}
