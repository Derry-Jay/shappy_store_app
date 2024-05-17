import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import 'package:shappy_store_app/src/pages/category_cum_product_add_and_edit_page.dart';
import 'package:shappy_store_app/src/controller/product_category_and_product_controller.dart';

class SearchProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchProductsPageState();
}

class SearchProductsPageState extends StateMVC<SearchProductsPage> {
  CategoryAndProductController _con;
  TextEditingController tc = new TextEditingController();
  SearchProductsPageState() : super(CategoryAndProductController()) {
    _con = controller;
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: Container(
                child: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              color: Colors.white,
              iconSize: 20,
              onPressed: () => Navigator.of(context).pop(),
            )),
            backgroundColor: Color(0xffe62136),
            actions: <Widget>[]),
        body: Column(children: [
          Stack(children: [
            Container(
              height: 70,
              width: double.infinity,
              padding: EdgeInsets.only(left: 20, top: 15),
              decoration: BoxDecoration(
                  color: Color(0xffe62136),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
            ),
            Container(
                child: TextField(
                    autofocus: true,
                    cursorColor: Colors.black,
                    controller: tc,
                    onChanged: _con.waitForSearchedProducts,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Search your Product',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.2)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.2))),
                    )),
                color: Colors.white,
                margin: EdgeInsets.all(10))
          ]),
          getProductList(_con.searchedProducts)
        ]));
  }

  Widget getProductList(List<Product> pq) => Visibility(
      child: Expanded(
          child: pq == null
              ? CircularLoadingWidget(
                  height: MediaQuery.of(context).size.height / 2)
              : (pq.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/img/empty_product.png"))),
                      height: MediaQuery.of(context).size.height / 5)
                  : ListView.builder(
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
                                          MediaQuery.of(context).size.height /
                                              50,
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              50),
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
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
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
                                              semanticLabel:
                                                  "Edit",
                                            ),
                                            onPressed: () {
                                              ProductCategory c;
                                              for (ProductCategory cat
                                                  in _con.categories)
                                                if (cat.proCat ==
                                                    pq[index].proCat) c = cat;
                                              navigateToAddCumEditPage(
                                                  'e',
                                                  'p',
                                                  c,
                                                  pq[index],
                                                  _con.categories);
                                            },
                                          ),
                                        ))
                                  ]),
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              500,
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              30),
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 50,
                                vertical:
                                    MediaQuery.of(context).size.height / 500));
                      }))),
      visible: pq != null && pq.isNotEmpty);

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
      // _con.waitForProductCategories(shopID: shopID);
      // _con.waitForProducts(shopID: shopID);
    });
  }
}
