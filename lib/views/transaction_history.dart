import 'dart:async';
import 'dart:math';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/views/add_expenses.dart';
import 'package:moneymanager/views/calendar_trxns.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<TransactionHistory> createState() {
    return new TransactionHistoryState();
  }
}

class TransactionHistoryState extends State<TransactionHistory>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final trxnListBloc = TrxnListBloc();

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
          color: Colors.redAccent,
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
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.date_range,
            color: Colors.blueAccent,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(model.trxnDate, style: TextStyle(color: Colors.black87))
        ],
      ),
      trailing: Text(
        model.trxnAmount,
        style: TextStyle(
            color: model.isWithDrawal ? Colors.redAccent : Colors.greenAccent,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  List<Tab> tabs = <Tab>[
    new Tab(
      key: Key('0'),
      child: Container(
        child: Text('Daily'),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      ),
    ),
    new Tab(
      key: Key('1'),
      child: Container(
        child: Text('Calendar'),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      ),
    ),
    new Tab(
      key: Key('2'),
      child: Container(
        child: Text('Weekly'),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      ),
    ),
    new Tab(
      key: Key('3'),
      child: Container(
        child: Text('Monthly'),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      ),
    ),
    new Tab(
      key: Key('4'),
      child: Container(
        child: Text('Yearly'),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      ),
    ),
  ];

  Widget getTrxnList() {
    return StreamBuilder<List<TransactionModel>>(
        stream: trxnListBloc.trxnModelListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.grey[100],
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  TransactionModel model = snapshot.data[index];
                  return getListCard(model);
                  // return StickyHeader(
                  //   header: Container(
                  //     height: 30.0,
                  //     color: Colors.grey[200],
                  //     padding: EdgeInsets.symmetric(horizontal: 16.0),
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       model.trxnDate,
                  //       style: const TextStyle(color: Colors.black87),
                  //     ),
                  //   ),
                  //   content: getListCard(model),
                  // );
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }

  List<Widget> getTabViewWidgets() {
    List<Widget> tabViewList = new List();
    for (var i = 0; i < tabs.length; i++) {
      switch (i) {
        case 1:
          tabViewList.add(CalendarWiseTransactions());
          break;
        default:
          tabViewList.add(getTrxnList());
      }
    }
    return tabViewList;
  }

  List<String> getDatesArray() {
    List<String> datesArray = new List();
    var currentDate = new DateTime.now();
    for (var i = currentDate.day; i > 0; i--) {
      var date = new DateTime(currentDate.year, currentDate.month, i);
      datesArray.add(new DateFormat("dd-MM-yyyy").format(date));
    }
    return datesArray;
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    trxnListBloc.updateTrxnList();
    _tabController.addListener(() {
      trxnListBloc.updateTrxnList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    trxnListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          'Transactions',
          style: TextStyle(color: Colors.black87),
        ),
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Colors.blueAccent,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box,
              color: Colors.black87,
            ),
            onPressed: () {
              addRecord();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: getTabViewWidgets(),
      ),
      floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpensesPage()),
            );
          },
        )
    );
  }

  Future addRecord() async {
    var categoryList = ['Investment', 'Food', 'income', 'rent', 'shopping'];
    var amountList = ['₹ 200', '₹ 250', '₹ 2000', '₹ 1000', '₹ 2500'];
    var titleList = [
      'New MF Purchase',
      'Dinner',
      'Salary',
      'Home rent',
      'Clothes Shopping'
    ];
    var dateList = [
      '23-03-2020',
      '24-03-2020',
      '21-03-2020',
      '12-03-2020',
      '02-03-2020'
    ];
    var typeList = [false, true];
    var db = new DatabaseHelper();
    final _random = new Random();
    var categoryElement = categoryList[_random.nextInt(categoryList.length)];
    var amountElement = amountList[_random.nextInt(amountList.length)];
    var titleElement = titleList[_random.nextInt(titleList.length)];
    var dateElement = dateList[_random.nextInt(dateList.length)];
    var typeElement = typeList[_random.nextInt(typeList.length)];
    var transaction = new TransactionModel(
        titleElement, amountElement, dateElement, categoryElement, typeElement);
    int insertValue = await db.saveTransaction(transaction);
    if (insertValue > 0) {
      setState(() {
        trxnListBloc.updateTrxnList();
      });
    }
    debugPrint('Insert Value is: $insertValue');
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
