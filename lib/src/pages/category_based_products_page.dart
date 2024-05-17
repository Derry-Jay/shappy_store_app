import 'dart:async';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'category_cum_product_add_and_edit_page.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/product_category_and_product_controller.dart';

class CategoryBasedProductsPage extends StatefulWidget {
  final RouteArgument rar;
  CategoryBasedProductsPage(this.rar);
  @override
  CategoryBasedProductsPageState createState() => CategoryBasedProductsPageState();
}

class CategoryBasedProductsPageState extends StateMVC<CategoryBasedProductsPage> {
  String shopID;
  CategoryAndProductController _con;
  CategoryBasedProductsPageState() : super(CategoryAndProductController()) {
    _con = controller;
  }

  void pickSessionData() async {
    _con.listenForCategoryBasedProducts(widget.rar.id);
    _con.waitForProductCategories(shopID: widget.rar.heroTag);
    _con.waitForUnits("Hi");
  }

  @override
  void initState() {
    pickSessionData();
    super.initState();
  }

  void navigateToAddCumEditPage(var ae, var pc, ProductCategory cat,
      Product pro, List<ProductCategory> cats) {
    List<MeasurementUnit> units = _con.units;
    Route route = MaterialPageRoute(
        builder: (context) =>
            AddOrEditProductAndCategoryPage(ae, pc, cat, pro, cats, units));
    Navigator.push(context, route).then(goBack);
  }

  FutureOr goBack(dynamic value) {
    setState(() {
      _con.listenForCategoryBasedProducts(widget.rar.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Toast.show("Add Product", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            navigateToAddCumEditPage(
                'a', 'p', widget.rar.param, null, _con.categories);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            semanticLabel: "Add",
          ),
          backgroundColor: Color(0xffe62136),
        ),
        appBar: AppBar(
            title: Text('Products'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            elevation: 0),
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Color(0xffe62136),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                padding: EdgeInsets.all(10)),
            getProductList(_con.categorizedProducts),
          ],
        ));
  }

  Widget getProductList(List<Product> pq) => pq == null
      ? CircularLoadingWidget(height: MediaQuery.of(context).size.height / 2)
      : (pq.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 4),
                  child: Image(
                    image: AssetImage('assets/img/empty_product.png'),
                  ),
                )
              ],
            )
          : Expanded(
              child: ListView.builder(
                  itemCount: pq.length,
                  itemBuilder: (BuildContext context, int index) {
                    String image =
                        pq[index].image == null ? "" : pq[index].image;
                    return Container(
                        child: InkWell(
                          child: Card(
                            elevation: 0,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 50,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 50),
                              child: Row(children: [
                                Visibility(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(image),
                                              fit: BoxFit.fill)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10)),
                                  visible: image != "",
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              30,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30),
                                      child: Text(
                                        pq[index].name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              50),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          // semanticLabel: "Edit" + pq[index].proCat,
                                        ),
                                        onPressed: () {
                                          navigateToAddCumEditPage(
                                              'e',
                                              'p',
                                              widget.rar.param,
                                              pq[index],
                                              _con.categories);
                                        },
                                      ),
                                    ))
                              ]),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 500,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 30),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 50,
                            vertical:
                                MediaQuery.of(context).size.height / 500));
                  })));
}
