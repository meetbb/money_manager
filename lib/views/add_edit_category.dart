import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/utilities/utils.dart';

class AddEditCategoryPage extends StatefulWidget {
  bool isEdit = false;

  bool isCategory = true;
  int editIndex = 0;
  int categoryIndex = 0;

  AddEditCategoryPage(
      {Key key,
      @required this.isEdit,
      this.editIndex,
      this.isCategory,
      this.categoryIndex});

  @override
  _AddEditCategoryPageState createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  TextEditingController categoryNameController = new TextEditingController();
  bool saveButtonEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit == true) {
      if (widget.isCategory == true) {
        categoryNameController.text =
            categorySubcategoryList[widget.editIndex]['name'];
      } else {
        categoryNameController.text =
            categorySubcategoryList[widget.categoryIndex]['subCategory']
                [widget.editIndex]['name'];
      }
      saveButtonEnabled = true;
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Category'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              maxLength: 50,
              controller: categoryNameController,
              onChanged: (text) {
                if (text.length == 0) {
                  saveButtonEnabled = false;
                } else {
                  saveButtonEnabled = true;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Category',
                  hintText: 'Enter Category'),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.blue.withOpacity(0.5),
              disabledTextColor: Colors.white,
              padding: EdgeInsets.all(16.0),
              splashColor: Colors.blueAccent,
              onPressed: saveButtonEnabled == true
                  ? () {
                      if (widget.isEdit) {
                        if (widget.isCategory == true) {
                          if (categorySubcategoryList[widget.editIndex]
                                  ['name'] ==
                              categoryNameController.text) {
                            showAlert(context, 'Don\'t enter same name');
                            return;
                          }
                          categorySubcategoryList[widget.editIndex]['name'] =
                              categoryNameController.text;
                          Navigator.pop(context, true);
                        } else {
                          if (categorySubcategoryList[widget.categoryIndex]
                                  ['subCategory'][widget.editIndex]['name'] ==
                              categoryNameController.text) {
                            showAlert(context, 'Don\'t enter same name');
                            return;
                          }
                          categorySubcategoryList[widget.categoryIndex]
                                  ['subCategory'][widget.editIndex]['name'] =
                              categoryNameController.text;
                          Navigator.pop(context, true);
                        }
                      } else {
                        if (widget.isCategory == true) {
                          dynamic lastCategory = categorySubcategoryList.last;
                          String latestCategoryId =
                              (int.parse(lastCategory['id']) + 1).toString();
                          Map<String, dynamic> latestCategory = Map();
                          latestCategory['id'] = latestCategoryId;
                          latestCategory['name'] = categoryNameController.text;
                          latestCategory['subCategory'] = List();
                          categorySubcategoryList.add(latestCategory);
                          Navigator.pop(context, true);
                        } else {
                          List<dynamic> subCategoryList =
                              categorySubcategoryList[widget.categoryIndex]
                                  ['subCategory'];
                          String latestSubCategoryId = '';
                          if (subCategoryList.length > 0) {
                            dynamic lastSubCategory = subCategoryList.last;
                            latestSubCategoryId =
                                (int.parse(lastSubCategory['id']) + 1)
                                    .toString();
                          } else {
                            latestSubCategoryId = '1';
                          }

                          Map<String, String> latestSubCategory = Map();
                          latestSubCategory['id'] = latestSubCategoryId;
                          latestSubCategory['name'] =
                              categoryNameController.text;
                          categorySubcategoryList[widget.categoryIndex]
                                  ['subCategory']
                              .add(latestSubCategory);
                          Navigator.pop(context, true);
                        }
                      }
                    }
                  : null,
              child: Text(
                "Save",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
