import 'package:shappy_store_app/src/models/product.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/pages/category_cum_product_add_and_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:async';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import '../controller/product_category_and_product_controller.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';

class SearchProductCategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchProductCategoriesPageState();
}

class SearchProductCategoriesPageState
    extends StateMVC<SearchProductCategoriesPage> {
  CategoryAndProductController _con;
  TextEditingController tc = new TextEditingController();
  SearchProductCategoriesPageState() : super(CategoryAndProductController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
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
                    onChanged: _con.waitForSearchedCategories,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Search your Product Category',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.2)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.2))),
                    )),
                color: Colors.white,
                margin: EdgeInsets.all(10))
          ]),
          getCategoryList(_con.searchedCategories)
        ]));
  }

  Widget getCategoryList(List<ProductCategory> cl) => Visibility(
      child: Expanded(
          child: cl == null
              ? CircularLoadingWidget(
                  height: MediaQuery.of(context).size.height / 2)
              : (cl.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/img/empty_category.png"))),
                      height: MediaQuery.of(context).size.height / 5)
                  : ListView.builder(
                      itemCount: cl.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                              child: InkWell(
                                child: Card(
                                  elevation: 0,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                60,
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                60),
                                    child: Row(children: [
                                      // Image(
                                      //     image: ResizeImage(AssetImage(pq[index].image),
                                      //         width: 100)),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    50,
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        30),
                                            child: Text(
                                              cl[index].proCat,
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
                                            padding: EdgeInsets.all(10),
                                            child: IconButton(
                                              icon: Icon(Icons.edit_outlined,
                                                  semanticLabel: "Edit"),
                                              onPressed: () =>
                                                  navigateToAddCumEditPage(
                                                      'e',
                                                      'c',
                                                      cl[index],
                                                      null,
                                                      null),
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
                                onTap: () => Navigator.pushNamed(
                                    context, '/CatProduct',
                                    arguments: RouteArgument(
                                        param: cl[index],
                                        id: cl[index].proCatID.toString(),
                                        heroTag: cl[index].shopID.toString())),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 500,
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          50))))),
      visible: cl != null && cl.isNotEmpty);

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
      // getData();
    });
  }
}
