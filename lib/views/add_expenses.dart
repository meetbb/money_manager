import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/views/category_selection.dart';

class AddExpensesPage extends StatefulWidget {
  @override
  _AddExpensesPageState createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  int _selectedTransactionType = 0;
  DateTime selectedDate = new DateTime.now();
  CategoryModel selectedCategory;
  SubCategoryModel selectedSubCategory;

  TextEditingController amountController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expenses'),
      ),
      body: GestureDetector(
        onTap: () {
          hideKeyboard();
        },
        child: Container(
          width: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: CupertinoSegmentedControl(
                      children: {
                        0: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 12, bottom: 12),
                          child: Text(
                            "Income",
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        1: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 12, bottom: 12),
                          child: Text(
                            "Expense",
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      },
                      groupValue: _selectedTransactionType,
                      onValueChanged: (value) {
                        setState(() => _selectedTransactionType = value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      hideKeyboard();
                      DateTime date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                      );
                      if (date != null) {
                        selectedDate = date;
                        setState(() {});
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 90,
                            margin: EdgeInsets.all(8),
                            child: Text(
                              'Date : ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(selectedDate),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 40,
                            width: 40,
                            decoration: new BoxDecoration(
                                color: Colors.blue,
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(40.0),
                                )),
                            margin: EdgeInsets.all(12),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: 90,
                          margin: EdgeInsets.all(8),
                          child: Text(
                            'Amount : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: amountController,
                              style: new TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                                hintText: "Amount",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                prefix: Text("₹ "),
                                prefixStyle: new TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                hasFloatingPlaceholder: true,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),

                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onChanged: (text) {},
                              // onSaved: (String value) => _formData["amount"] = value,
                              validator: (String value) {
                                if (!RegExp(
                                        r"^\-?\(?\$?\s*\-?\s*\(?(((\d{1,3}((\,\d{3})*|\d*))?(\.\d{1,4})?)|((\d{1,3}((\,\d{3})*|\d*))(\.\d{0,4})?))\)?$")
                                    .hasMatch(value)) {
                                  return "Please enter a valid amount\n";
                                }

                                if (value.length == 0) {
                                  return "An amount is required.";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 40,
                          width: 40,
                          decoration: new BoxDecoration(
                              color: Colors.green.withOpacity(0.9),
                              borderRadius: new BorderRadius.all(
                                Radius.circular(40.0),
                              )),
                          margin: EdgeInsets.all(12),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      hideKeyboard();
                      List<dynamic> selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySelection()),
                      );
                      if (selected != null) {
                        selectedCategory = selected[0];
                        if (selected.length > 1) {
                          selectedSubCategory = selected[1];
                        } else {
                          selectedSubCategory = null;
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 90,
                            margin: EdgeInsets.all(8),
                            child: Text(
                              'Category: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    selectedCategory != null
                                        ? selectedSubCategory != null
                                            ? selectedCategory.categoryName +
                                                ' / ' +
                                                selectedSubCategory
                                                    .subCategoryName
                                            : selectedCategory.categoryName
                                        : 'Uncategorized',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 40,
                            width: 40,
                            decoration: new BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.9),
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(40.0),
                                )),
                            margin: EdgeInsets.all(12),
                            child: Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: 90,
                          margin: EdgeInsets.all(8),
                          child: Text(
                            'Description : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              maxLines: 3,
                              controller: descriptionController,
                              style: new TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                                hintText: "Description",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                // prefix: Text("₹ "),
                                prefixStyle: new TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                hasFloatingPlaceholder: true,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),

                              // keyboardType: TextInputType.numberWithOptions(
                              //     decimal: true),
                              onChanged: (text) {},
                              // onSaved: (String value) => _formData["amount"] = value,
                              validator: (String value) {
                                if (!RegExp(
                                        r"^\-?\(?\$?\s*\-?\s*\(?(((\d{1,3}((\,\d{3})*|\d*))?(\.\d{1,4})?)|((\d{1,3}((\,\d{3})*|\d*))(\.\d{0,4})?))\)?$")
                                    .hasMatch(value)) {
                                  return "Please enter a valid amount\n";
                                }

                                if (value.length == 0) {
                                  return "An amount is required.";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 40,
                          width: 40,
                          decoration: new BoxDecoration(
                              color: Colors.grey.withOpacity(0.9),
                              borderRadius: new BorderRadius.all(
                                Radius.circular(40.0),
                              )),
                          margin: EdgeInsets.all(12),
                          child: Icon(
                            Icons.description,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.blue.withOpacity(0.5),
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      hideKeyboard();
                      //save transaction
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
