import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/utilities/utils.dart';
import 'package:moneymanager/views/add_edit_category.dart';
import 'package:moneymanager/views/subcategory_list.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        // if (newIndex > oldIndex) {
        //   newIndex -= 1;
        // }
        if (newIndex > categorySubcategoryList.length)
          newIndex = categorySubcategoryList.length;
        if (oldIndex < newIndex) newIndex--;
        final dynamic item = categorySubcategoryList.removeAt(oldIndex);
        categorySubcategoryList.insert(newIndex, item);
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
                onPressed: () async {
                  var isAddOrEdit = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditCategoryPage(
                              isEdit: false,
                              isCategory: true,
                            )),
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
            children: List.generate(categorySubcategoryList.length, (index) {
              List<dynamic> subCategories =
                  categorySubcategoryList[index]['subCategory'];

              return Container(
                key: Key('$index'),
                child: GestureDetector(
                  onTap: () async {
                    // if (subCategories.length > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubCategoryListPage(
                                  categoryIndex: index,
                                )),
                      );
                    // }
                  },
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showAlertWithConfirmation(
                                  context, 'Are you sure want to delete ?', () {
                                categorySubcategoryList.removeAt(index);
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
                            categorySubcategoryList[index]['name'] +
                                ' (' +
                                subCategories.length.toString() +
                                ')',
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
                                          isCategory: true,
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
