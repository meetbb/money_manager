import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/views/category_list.dart';

class CategorySelection extends StatefulWidget {
  final int categoryType;
  // Function onSelection;
  CategorySelection({Key key, this.categoryType});
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  // List<CategoryModel> categoryList = List();

  @override
  void initState() {
    super.initState();
    // getCategories();
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categoryList =
        await databaseWrapper.getCategoryList(widget.categoryType);
    // setState(() {});
    return categoryList;
  }

  void choiceAction(String choice) {
    if (choice == 'Edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryListPage(
                  categoryType: widget.categoryType,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          color: Colors.white, //Color(0xFFefefef),
          borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
      // appBar: new AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: new Text(
      //     "Category / Sub Category",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   // actions: <Widget>[
      //   //   PopupMenuButton<String>(
      //   //     onSelected: choiceAction,
      //   //     itemBuilder: (BuildContext context) {
      //   //       return ['Edit'].map((String choice) {
      //   //         return PopupMenuItem<String>(
      //   //           value: choice,
      //   //           child: Text(choice),
      //   //         );
      //   //       }).toList();
      //   //     },
      //   //   )
      //   // ]
      // ),
      child: FutureBuilder<List<CategoryModel>>(
          future: getCategories(), //
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoryModel>> snapshot) {
            return snapshot.hasData
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(8),
                        child: new Text(
                          "Category / Sub Category",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return new ExpandableListView(
                                category: snapshot.data[index]);
                          },
                          itemCount: snapshot.data.length,
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class ExpandableListView extends StatefulWidget {
  final CategoryModel category;

  ExpandableListView({Key key, this.category}) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  Future<List<SubCategoryModel>> getSubCategories(int catId) async {
    List<SubCategoryModel> subCategoryList =
        await databaseWrapper.getSubCategoryList(catId);
    return subCategoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new ExpansionTile(
        onExpansionChanged: (isExpaded) async {
          List<SubCategoryModel> subCategoryList =
              await getSubCategories(widget.category.categoryId);
          if (subCategoryList.length == 0) {
            List<dynamic> selectedCategories = List();
            selectedCategories.add(widget.category);
            Navigator.pop(context, selectedCategories);
          }
        },
        title: Row(
          children: <Widget>[
            new Container(
              height: 40,
              width: 40,
              decoration: new BoxDecoration(
                  color: UniqueColorGenerator.getColor(),
                  borderRadius: new BorderRadius.all(
                    Radius.circular(40.0),
                  )),
              child: Center(
                  child: Text(
                '${widget.category.categoryName[0]}',
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: new Text(
                widget.category.categoryName,
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: <Widget>[
              FutureBuilder<List<SubCategoryModel>>(
                  future: getSubCategories(widget.category.categoryId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SubCategoryModel>> snapshot) {
                    return snapshot.hasData
                        ? new ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  debugPrint('Category : ' +
                                      widget.category.categoryName +
                                      ' Subcateogry : ' +
                                      snapshot.data[index].subCategoryName);
                                  List<dynamic> selectedCategories = List();
                                  selectedCategories.add(widget.category);
                                  selectedCategories.add(snapshot.data[index]);

                                  Navigator.pop(context, selectedCategories);
                                },
                                child: new Container(
                                  child: new ListTile(
                                    title: new Text(
                                      snapshot.data[index].subCategoryName,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54),
                                    ),
                                    leading: new Icon(
                                      Icons.local_pizza,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data.length,
                          )
                        : Container();
                  })
            ],
          ),
        ],
      ),
    );
  }
}
