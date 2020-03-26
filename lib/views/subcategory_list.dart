import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/utilities/utils.dart';
import 'package:moneymanager/views/add_edit_category.dart';

class SubCategoryListPage extends StatefulWidget {
  final CategoryModel category;

  SubCategoryListPage({
    Key key,
    this.category,
  });
  @override
  _SubCategoryListPageState createState() => _SubCategoryListPageState();
}

class _SubCategoryListPageState extends State<SubCategoryListPage> {
  List<SubCategoryModel> subCategoryList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSubCategories();
  }

  getSubCategories() async {
    subCategoryList =
        await databaseWrapper.getSubCategoryList(widget.category.categoryId);

    setState(() {});
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
          title: Text(widget.category.categoryName),
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
                              isCategory: false,
                              category: widget.category,
                            )),
                  );
                  if (isAddOrEdit != null) {
                    getSubCategories();
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
                                // editIndex: index,
                                isCategory: false,
                                category: widget.category,
                                subCategory: subCategoryList[index],
                                // categoryIndex: widget.categoryIndex,
                              )),
                    );
                    if (isAddOrEdit != null) {
                      getSubCategories();
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showAlertWithConfirmation(
                                  context, 'Are you sure want to delete ?',
                                  () async {
                                databaseHelper
                                    .deleteSubCategory(subCategoryList[index]);
                                getSubCategories();
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
                            subCategoryList[index].subCategoryName,
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
                                          // editIndex: index,
                                          isCategory: false,
                                          category: widget.category,
                                          subCategory: subCategoryList[index],
                                          // categoryIndex: widget.categoryIndex,
                                        )),
                              );
                              if (isAddOrEdit != null) {
                                getSubCategories();
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
