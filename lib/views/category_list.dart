import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<dynamic> categoryList = [
    {'id': '1', 'name': 'Transportation'},
    {'id': '2', 'name': 'Food'},
    {'id': '3', 'name': 'Social Life'},
    {'id': '4', 'name': 'Self-development'},
    {'id': '5', 'name': 'Culture'},
    {'id': '6', 'name': 'Household'},
    {'id': '7', 'name': 'Apparel'},
    {'id': '8', 'name': 'Beauty'},
    {'id': '9', 'name': 'Health'},
    {'id': '10', 'name': 'Education'},
    {'id': '11', 'name': 'Gift'},
    {'id': '12', 'name': 'Other'},
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        // if (newIndex > oldIndex) {
        //   newIndex -= 1;
        // }
        if (newIndex > categoryList.length) newIndex = categoryList.length;
        if (oldIndex < newIndex) newIndex--;
        final dynamic item = categoryList.removeAt(oldIndex);
        categoryList.insert(newIndex, item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Expenses Category'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: null)
          ],
        ),
        body: SafeArea(
          child: ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: List.generate(categoryList.length, (index) {
              return Container(
                key: Key('$index'),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            //delete clicked
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red.withOpacity(0.7),
                              size: 28,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                          categoryList[index]['name'],
                          style: TextStyle(fontSize: 16),
                        )),
                        GestureDetector(
                          onTap: () {
                            //edit clicked
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.list,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.grey.withOpacity(0.5),
                    )
                  ],
                ),
              );
            }),
          ),
        ));
  }
}
