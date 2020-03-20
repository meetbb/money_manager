import 'package:flutter/material.dart';
import 'package:moneymanager/views/transaction_history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Expense Manager',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Category',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    TransactionHistory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),    
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            title: Text('Add')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), title: Text('Overview')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

//this is for testing commit by parimal
