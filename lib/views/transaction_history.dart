import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<TransactionHistory> createState() {
    return new TransactionHistoryState();
  }
}

class TransactionHistoryState extends State<TransactionHistory> {
  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text('Transactions'),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.list),
        onPressed: () {},
      )
    ],
  );

  Widget getListCard() {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
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
            right: new BorderSide(width: 1.0, color: Colors.white24),
          ),
        ),
        child: Icon(Icons.money_off, color: Colors.white),
      ),
      title: Text(
        "For food donation",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.linear_scale, color: Colors.yellowAccent),
              Text(" Rs. 2000",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic))
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
                color: Colors.yellowAccent,
                size: 16,
              ),
              Text(" 10 March, 2020", style: TextStyle(color: Colors.white))
            ],
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return getListCard();
          },
        ),
      ),
    );
  }
}
