import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shappy_store_app/src/models/faq.dart';
import 'package:shappy_store_app/src/controller/accounts_cum_faq_controller.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';

class FrequentlyAskedQuestionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FrequentlyAskedQuestionsPageState();
}

class FrequentlyAskedQuestionsPageState
    extends StateMVC<FrequentlyAskedQuestionsPage> {
  AccountsAndFrequentlyAskedQuestionsController _con;
  FrequentlyAskedQuestionsPageState()
      : super(AccountsAndFrequentlyAskedQuestionsController()) {
    _con = controller;
  }
  void initState() {
    _con.waitForFaq(faqType: 0);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text("Faq & Support"),
            backgroundColor: Color(0xffe62136),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height / 50,
                decoration: BoxDecoration(
                    color: Color(0xffe62136),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)))),
            Expanded(
                // alignment: Alignment.centerRight,
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: InkWell(
                                child: Card(
                                  elevation: 0,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        FlatButton(
                                            onPressed: () =>
                                                launch("tel://9841035657"),
                                            child: Icon(
                                                Icons.wifi_calling_outlined,
                                                size: 31)),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              110,
                                        ),
                                        Text("9841035657",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17))
                                      ],
                                    ),
                                    // padding: EdgeInsets.all(15),
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                50,
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                20),
                                  ),
                                ),
                                onTap: () => launch("tel://7338965667")),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 80,
                          ),
                          Expanded(
                              flex: 2,
                              child: InkWell(
                                  child: Card(
                                    elevation: 0,
                                    child: Container(
                                        child: Column(
                                          children: [
                                            FlatButton(
                                                onPressed: () => launch(
                                                    "https://mail.google.com/mail/u/0/?pli=1#inbox?compose=new"),
                                                child: Icon(
                                                    Icons.mail_outline_rounded,
                                                    size: 31)),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  105,
                                            ),
                                            Text("mail@mail.com",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17))
                                          ],
                                        ),
                                        padding: EdgeInsets.all(15)),
                                  ),
                                  onTap: () => launch(
                                      "https://mail.google.com/mail/u/0/?pli=1#inbox?compose=new")))
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 55)),
                  _con.faqs == null || _con.faqs.length == 0
                      ? CircularLoadingWidget(
                          height: MediaQuery.of(context).size.height / 50
                        )
                      : buildList(_con.faqs)
                ],
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 50),
            ))
          ],
        ),
        backgroundColor: Color(0xfff3f2f2));
  }

  Widget buildList(List<FrequentlyAskedQuestions> faqs) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: faqs.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 50),
              child: Card(
                elevation: 0,
                child: ExpansionTile(
                    title: Text(faqs[index].question,
                        style: TextStyle(color: Colors.black, fontSize: 19)),
                    children: [
                      Container(
                          child: Text(faqs[index].answer,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 25,
                              vertical:
                                  MediaQuery.of(context).size.height / 80))
                    ]),
              ));
        });
  }
}
