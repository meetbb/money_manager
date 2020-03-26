import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/views/add_expenses.dart';
import 'package:moneymanager/views/calendar_trxns.dart';

import 'budget/budget_screen.dart';

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
    return GestureDetector(
      onTap: () async {
        bool isAddEdit = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExpensesPage(
                    isEdit: true,
                    trxn: model,
                  )),
        );
        if (isAddEdit != null) {
          trxnListBloc.updateTrxnList(_tabController.index);
        }
      },
      child: Card(
        margin: new EdgeInsets.only(top: 10, left: 10, right: 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          decoration: BoxDecoration(color: Colors.white70),
          child: getListTile(model),
        ),
      ),
    );
  }

  Widget getListTile(TransactionModel model) {
    String imageAsset = '';
    switch (model.categoryId.toString()) {
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
        model.description,
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
        model.trxnAmount.toString(),
        style:
            TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600),
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
            return Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator()),
              ],
            );
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
    trxnListBloc.updateTrxnList(_tabController.index);
    _tabController.addListener(() {
      trxnListBloc.updateTrxnList(_tabController.index);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BudgetScreen()),
                );
                // addRecord();
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
          onPressed: () async {
            bool isAddEdit = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExpensesPage(isEdit: false)),
            );
            if (isAddEdit != null) {
              trxnListBloc.updateTrxnList(_tabController.index);
            }
          },
        ));
  }
}

class TrxnListBloc {
  StreamController<List<TransactionModel>> controller =
      new StreamController.broadcast();

  int getWeekOfYear(DateTime date) {
    final weekYearStartDate = getWeekYearStartDateForDate(date);
    final dayDiff = date.difference(weekYearStartDate).inDays;
    return ((dayDiff + 1) / 7).ceil();
  }

  DateTime getWeekYearStartDateForDate(DateTime date) {
    int weekYear = getWeekYear(date);
    return getWeekYearStartDate(weekYear);
  }

  int getWeekYear(DateTime date) {
    assert(date.isUtc);

    final weekYearStartDate = getWeekYearStartDate(date.year);

    // in previous week year?
    if (weekYearStartDate.isAfter(date)) {
      return date.year - 1;
    }

    // in next week year?
    final nextWeekYearStartDate = getWeekYearStartDate(date.year + 1);
    if (date.isAfter(nextWeekYearStartDate)) {
      return date.year + 1;
    }

    return date.year;
  }

  isBeforeOrEqual(nextWeekYearStartDate, date) {}
  // if(date.isAfter(nextWeekYearStartDate)||Utils.isSameDay(date, nextWeekYearStartDate)){ return date.year + 1; } and if(dayOfWeek <= DateTime.thursday) { return firstDayOfYear.subtract(Duration(days: dayOfWeek-1)); } else { return firstDayOfYear.add(Duration(days:8 - dayOfWeek )) }

//  return firstDayOfYear.subtract(Duration(days: dayOfWeek-1)); } else { return firstDayOfYear.add(Duration(days:8 - dayOfWeek )) }

  DateTime getWeekYearStartDate(int year) {
    final firstDayOfYear = DateTime.utc(year, 1, 1);
    final dayOfWeek = firstDayOfYear.weekday;
    if (dayOfWeek <= DateTime.thursday) {
      return firstDayOfYear.subtract(Duration(days: dayOfWeek - 1));
    } else {
      firstDayOfYear.add(Duration(days: 8 - dayOfWeek));
    }
  }

  void updateTrxnList(int index) async {
    debugPrint('tabbar controller index : ' + index.toString());
    DateTime date = new DateTime.now();
    String stDate = '';
    String enDate = '';

    if (index == 0) {
      stDate = DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now());
      enDate = DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now());
      //weekly
    } else if (index == 2) {
      DateTime monday = DateTime.utc(date.year, date.month, date.day);
      monday = monday.subtract(Duration(days: monday.weekday - 1));

      stDate = DateFormat('yyyy-MM-dd 00:00:00').format(monday);
      enDate = DateFormat('yyyy-MM-dd 23:59:59')
          .format(monday.add(new Duration(days: 6)));
    } else if (index == 3) {
      DateTime monthStartDate = DateTime.utc(date.year, date.month - 1, 1);
      DateTime monthEndDate = DateTime.utc(date.year, date.month + 1, 1)
          .subtract(new Duration(days: 1));
      stDate = DateFormat('yyyy-MM-dd 00:00:00').format(monthStartDate);
      enDate = DateFormat('yyyy-MM-dd 23:59:59').format(monthEndDate);
    } else if (index == 4) {
      DateTime yearStartDate = DateTime.utc(date.year, 1, 1);
      DateTime yearEndDate =
          DateTime.utc(date.year + 1, 1, 1).subtract(new Duration(days: 1));

      stDate = DateFormat('yyyy-MM-dd 00:00:00').format(yearStartDate);
      enDate = DateFormat('yyyy-MM-dd 23:59:59').format(yearEndDate);

      debugPrint('St Date :' + stDate);
      debugPrint('end Date :' + enDate);
    }

    List<TransactionModel> trxnList =
        await databaseWrapper.getTrxnListByDate(stDate, enDate);
    controller.sink.add(trxnList);
  }

  void dispose() {
    controller.close();
  }

  Stream get trxnModelListStream => controller.stream;
}
