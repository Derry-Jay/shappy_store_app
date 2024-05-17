import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/product_category_and_product_controller.dart';

class ProductsStatusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductsStatusPageState();
}

class ProductsStatusPageState extends StateMVC<ProductsStatusPage> {
  String shopID;
  CategoryAndProductController _con;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  ProductsStatusPageState() : super(CategoryAndProductController()) {
    _con = controller;
  }
  void pickSessionData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    shopID = sharedPrefs.getString("spShopID");
    _con.waitForProducts(shopID: shopID);
  }

  void initState() {
    pickSessionData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text("My Store"),
            backgroundColor: Color(0xffe62136),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 30,
                decoration: BoxDecoration(
                    color: Color(0xffe62136),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)))),
            _con.products == null
                ? CircularLoadingWidget(
                    height: MediaQuery.of(context).size.height / 1.25)
                : getList(_con.products)
          ],
        ),
        backgroundColor: Color(0xfff3f2f2));
  }

  Widget getList(List<Product> pq) {
    return pq == null
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
                flex: 2,
                child: ListView.builder(
                    itemCount: pq.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool val = pq[index].productStatus == 1;
                      String image = pq[index].image == null ||
                              pq[index].image == "null" ||
                              pq[index].image == ""
                          ? ""
                          : pq[index].image;
                      return Card(
                        elevation: 0,
                        child: Container(
                          child: Row(children: [
                            Visibility(
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(image),
                                          fit: BoxFit.contain)),
                                  padding: EdgeInsets.all(40)),
                              visible: image != "",
                            ),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Text(
                                    pq[index].name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.all(10),
                                  child: Switch(
                                    activeColor: Color(0xff57c901),
                                    activeTrackColor: Color(0xff57c901),
                                    inactiveThumbColor: Color(0xffe62337),
                                    inactiveTrackColor: Color(0xffe62337),
                                    value: val,
                                    onChanged: (boolean) {
                                      _con.setStatus(index);
                                      setState(() => val = boolean);
                                    },
                                  ),
                                ))
                          ]),
                          padding: EdgeInsets.all(10),
                        ),
                      );
                    }),
              ));
  }
}
