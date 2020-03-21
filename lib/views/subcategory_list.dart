import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/utilities/utils.dart';
import 'package:moneymanager/views/add_edit_category.dart';

class SubCategoryListPage extends StatefulWidget {
  final int categoryIndex;
  SubCategoryListPage({
    Key key,
    this.categoryIndex,
  });
  @override
  _SubCategoryListPageState createState() => _SubCategoryListPageState();
}

class _SubCategoryListPageState extends State<SubCategoryListPage> {
  List<dynamic> subCategoryList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subCategoryList =
        categorySubcategoryList[widget.categoryIndex]['subCategory'];
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > subCategoryList.length)
          newIndex = subCategoryList.length;
        if (oldIndex < newIndex) newIndex--;
        final dynamic item = subCategoryList.removeAt(oldIndex);
        subCategoryList.insert(newIndex, item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(categorySubcategoryList[widget.categoryIndex]['name']),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var isAddOrEdit = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditCategoryPage(
                            isEdit: false,
                            categoryIndex: widget.categoryIndex)),
                  );
                  if (isAddOrEdit != null) {
                    setState(() {});
                  }
                })
          ],
        ),
        body: SafeArea(
          child: ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: List.generate(subCategoryList.length, (index) {
              return Container(
                key: Key('$index'),
                child: GestureDetector(
                  onTap: () async {
                    var isAddOrEdit = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddEditCategoryPage(
                                isEdit: true,
                                editIndex: index,
                                isCategory: false,
                                categoryIndex: widget.categoryIndex,
                              )),
                    );
                    if (isAddOrEdit != null) {
                      setState(() {});
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showAlertWithConfirmation(
                                  context, 'Are you sure want to delete ?', () {
                                subCategoryList.removeAt(index);
                                setState(() {});
                              });
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
                            subCategoryList[index]['name'],
                            style: TextStyle(fontSize: 16),
                          )),
                          GestureDetector(
                            onTap: () async {
                              //edit clicked
                              var isAddOrEdit = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEditCategoryPage(
                                          isEdit: true,
                                          editIndex: index,
                                          isCategory: false,
                                          categoryIndex: widget.categoryIndex,
                                        )),
                              );
                              if (isAddOrEdit != null) {
                                setState(() {});
                              }
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
                ),
              );
            }),
          ),
        ));
  }
}
