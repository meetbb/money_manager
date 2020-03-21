import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/views/calendar_trxns.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<TransactionHistory> createState() {
    return new TransactionHistoryState();
  }
}

class TransactionHistoryState extends State<TransactionHistory>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget getListCard() {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white70),
        child: getListTile(),
      ),
    );
  }

  Widget getListTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: Icon(Icons.money_off, color: Colors.black87),
      ),
      title: Text(
        "For food donation",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.linear_scale, color: Colors.orangeAccent),
              Text(" Rs. 2000",
                  style: TextStyle(
                      color: Colors.black87, fontStyle: FontStyle.italic))
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
              Text(" 10 March, 2020", style: TextStyle(color: Colors.black87))
            ],
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.black45, size: 30.0),
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
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return StickyHeader(
            header: Container(
              height: 30.0,
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                getDatesArray()[index],
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            content: getListCard(),
          );
        },
      ),
    );
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
    );
  }

  Future addRecord() async {
    var db = new DatabaseHelper();
    var transaction = new TransactionModel(
        "New MF Purchase", "£ 200", "20-03-2020", "Investment");
    int insertValue = await db.saveTransaction(transaction);
    debugPrint('Insert Value is: $insertValue');
  }
}

