import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/views/settings.dart';
import 'package:moneymanager/views/stats.dart';
import 'package:moneymanager/views/transaction_history.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> tabsViews = [TransactionHistory(), StatsPage(), SettingPage()];

  @override
  void initState() {
    super.initState();
    setDatabase();
  }

  void setDatabase() async {
    databaseHelper = new DatabaseHelper();
    await databaseHelper.createCategoryTable(await databaseHelper.db);
  }

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: tabsViews,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text('Trans')),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), title: Text('Stats')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Setting')),
        ],
        currentIndex: _selectedIndex,
        // unselectedItemColor: Colors.black,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
