import 'dart:async';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/pages/category_cum_product_add_and_edit_page.dart';
import 'package:shappy_store_app/src/controller/product_category_and_product_controller.dart';

class CategoriesAndProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoriesAndProductsPageState();
}

class CategoriesAndProductsPageState extends StateMVC<CategoriesAndProductsPage>
    with TickerProviderStateMixin {
  TabController tabCon;
  String shopID;
  int specificPage = 0;
  CategoryAndProductController _con;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  CategoriesAndProductsPageState() : super(CategoryAndProductController()) {
    _con = controller;
  }

  void pickSessionData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    // tabCon = new TabController(length: 2, vsync: this);
    shopID = sharedPrefs.getString("spShopID");
    _con.waitForProductCategories(shopID: shopID);
    _con.waitForProducts(shopID: shopID);
    _con.waitForUnits("Hi");
  }

  void setTab() {
    // if(_tabController.offset>-1.0 && _tabController.offset<=0.0)
    //   setState(() =>specificPage = 0);
    // else if(tabCon.offset>=0.0 && tabCon.offset<1.0)
    //   setState(() =>specificPage = 1);
    // if (tabCon.index != tabCon.previousIndex)
    setState(() => specificPage = tabCon.index);
  }

  void setTabWhilePress(int a) {
    setState(() => specificPage = a);
  }

  @protected
  @mustCallSuper
  void didChangeDependencies() {
    pickSessionData();
    super.didChangeDependencies();
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

  void navigateTo(String route, RouteArgument arguments) {
    Navigator.pushNamed(context, route, arguments: arguments).then(goBack);
  }

  FutureOr goBack(dynamic value) {
    setState(() {
      _con.waitForProductCategories(shopID: shopID);
      _con.waitForProducts(shopID: shopID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: tabCon == null ? 0 : tabCon.index,
        length: 2,
        child: Builder(
          builder: (context) {
            tabCon = DefaultTabController.of(context);
            tabCon.addListener(setTab);
            print(tabCon.index);
            print("=-=-=-");
            return Scaffold(
                floatingActionButton: Visibility(
                    child: FloatingActionButton(
                      onPressed: () {
                        print(specificPage);
                        Toast.show(
                            "Add " +
                                (specificPage == 1 ? "Product" : "Category"),
                            context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                        navigateToAddCumEditPage(
                            'a',
                            specificPage == 1 ? 'p' : 'c',
                            null,
                            null,
                            specificPage == 1 ? _con.categories : null);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        semanticLabel: "Add",
                      ),
                      backgroundColor: Color(0xffe62136),
                    ),
                    visible: !tabCon.indexIsChanging),
                appBar: AppBar(
                    title: Text("Products"),
                    centerTitle: true,
                    backgroundColor: Color(0xffe62136),
                    bottom: TabBar(
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(text: 'Category'),
                          // Tab(text: 'Sub Category'),
                          Tab(
                            text: 'Products',
                          )
                        ],
                        onTap: setTabWhilePress,
                        controller: tabCon),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            if (specificPage == 0) {
                              Navigator.pushNamed(context, "/catSearch");
                            } else if (specificPage == 1) {
                              Navigator.pushNamed(context, "/proSearch");
                            } else
                              print('refreshing stocks...');
                          })
                    ],
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                body: TabBarView(
                  controller: tabCon,
                  children: [
                    // Text("Hey"),Text("Hi")
                    getCategoryList(_con.categories),
                    // generateList(subCatList),
                    getProductList(_con.products)
                  ],
                ),
                backgroundColor: Color(0xfff3f2f2));
          },
        ));
  }

  Widget getProductList(List<Product> pq) => pq == null
      ? CircularLoadingWidget(height: MediaQuery.of(context).size.height / 2)
      : (pq.isEmpty
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/empty_product.png"))),
              height: MediaQuery.of(context).size.height / 5)
          : ListView.builder(
              itemCount: pq.length,
              itemBuilder: (BuildContext context, int index) {
                String image = pq[index].image == null ? "" : pq[index].image;
                return Container(
                    child: InkWell(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 50,
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
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              20,
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              10)),
                              visible: image != "",
                            ),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              30,
                                      horizontal:
                                          MediaQuery.of(context).size.width /
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
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              50),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      semanticLabel: "Edit" + pq[index].proCat,
                                    ),
                                    onPressed: () {
                                      ProductCategory c;
                                      for (ProductCategory cat
                                          in _con.categories)
                                        if (cat.proCat == pq[index].proCat)
                                          c = cat;
                                      navigateToAddCumEditPage('e', 'p', c,
                                          pq[index], _con.categories);
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
                        vertical: MediaQuery.of(context).size.height / 500));
              }));

  Widget getCategoryList(List<ProductCategory> cl) => cl == null
      ? CircularLoadingWidget(height: MediaQuery.of(context).size.height / 2)
      : (cl.isEmpty
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/empty_category.png"))),
              height: MediaQuery.of(context).size.height / 5)
          : ListView.builder(
              itemCount: cl.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: InkWell(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 60,
                              horizontal:
                                  MediaQuery.of(context).size.width / 60),
                          child: Row(children: [
                            // Image(
                            //     image: ResizeImage(AssetImage(pq[index].image),
                            //         width: 100)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      horizontal:
                                          MediaQuery.of(context).size.width /
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
                                    onPressed: () {
                                      navigateToAddCumEditPage(
                                          'e', 'c', cl[index], null, null);
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
                      onTap: () => navigateTo(
                          '/CatProduct',
                          RouteArgument(
                              param: cl[index],
                              id: cl[index].proCatID.toString(),
                              heroTag: cl[index].shopID.toString())),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 500,
                        horizontal: MediaQuery.of(context).size.width / 50));
              }));
}
