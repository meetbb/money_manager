import 'dart:async';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/views/uiwidgets/trxn_chart.dart';
import 'package:flutter/src/painting/text_style.dart' as textlib;
import 'package:flutter/src/painting/basic_types.dart' as basicdesign;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final trxnListBloc = TrxnListBloc();

  @override
  void initState() {
    super.initState();
    trxnListBloc.updateTrxnList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200,
              child: Center(
                child: DonutAutoLabelChart.withRandomData(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            getTrxnList()
          ],
        ),
      ),
    );
  }

  Widget getListCard(TransactionModel model) {
    return Card(
      margin: new EdgeInsets.only(top: 10, left: 10, right: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white70),
        child: getListTile(model),
      ),
    );
  }

  Widget getListTile(TransactionModel model) {
    String imageAsset = '';
    switch (model.trxnCategory) {
      case "Investment":
        imageAsset = 'assets/rent.svg';
        break;
        case "Food":
        imageAsset = 'assets/food.svg';
        break;
        case "income":
        imageAsset = 'assets/salary.svg';
        break;
        case "rent":
        imageAsset = 'assets/rent.svg';
        break;
        case "shopping":
        imageAsset = 'assets/shopping.svg';
        break;
      default:
      imageAsset = 'assets/home.svg';
    }
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.pink[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            imageAsset,
            width: 22,
            height: 22,
          ),
        ),
      ),
      title: Text(
        model.trxnName,
        style: textlib.TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.linear_scale, color: Colors.orangeAccent),
              Text(
                model.trxnAmount,
                style: textlib.TextStyle(
                    color: Colors.black87, fontStyle: FontStyle.italic),
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
                color: Colors.orangeAccent,
                size: 16,
              ),
              Text(model.trxnDate,
                  style: textlib.TextStyle(color: Colors.black87))
            ],
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.black45, size: 30.0),
    );
  }

  Widget getTrxnList() {
    return StreamBuilder<List<TransactionModel>>(
        stream: trxnListBloc.trxnModelListStream,
        builder: (context, snapshot) {
          if (snapshot. hasData) {
            return Container(
              color: Colors.grey[100],
              child: ListView.builder(
                scrollDirection: basicdesign.Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  TransactionModel model = snapshot.data[index];
                  return getListCard(model);
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class TrxnListBloc {
  StreamController<List<TransactionModel>> controller =
      new StreamController.broadcast();
  var db = new DatabaseHelper();

  void updateTrxnList() async {
    List<TransactionModel> trxnList = await db.getTrxnList();
    controller.sink.add(trxnList);
  }

  void dispose() {
    controller.close();
  }

  Stream get trxnModelListStream => controller.stream;
}
