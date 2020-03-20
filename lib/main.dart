import 'package:flutter/material.dart';
import 'package:moneymanager/views/category_list.dart';
import 'package:moneymanager/views/settings.dart';
import 'package:moneymanager/views/trans.dart';

void main() => runApp(MyApp());

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
  MyHomePage({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void updateIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> tabsViews = [TransactionPage(), CategoryListPage(), SettingPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: selectedIndex,
          children: tabsViews,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: updateIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), title: Text('Stats')),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), title: Text('Overview')),
        ],
      ),
    );
  }
}
