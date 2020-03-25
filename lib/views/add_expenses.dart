import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/utilities/utils.dart';
import 'package:moneymanager/views/category_selection.dart';

class AddExpensesPage extends StatefulWidget {
  @override
  _AddExpensesPageState createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  int trxnType = 0;
  DateTime selectedDate = null; //new DateTime.now();
  CategoryModel selectedCategory;
  SubCategoryModel selectedSubCategory;

  TextEditingController amountController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  void initState() {
    super.initState();
    // amountController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add Expenses',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: GestureDetector(
        onTap: () {
          hideKeyboard();
        },
        child: Container(
          color: Colors.white,
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
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width - 60,
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: Color(0xFFefefef),
                      thumbColor:
                          trxnType == 0 ? Color(0xFFFF7070) : Color(0xFF697af8),
                      children: {
                        0: Container(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 12, bottom: 12),
                          child: Text(
                            "Expense",
                            style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: trxnType == 0
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        1: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 12, bottom: 12),
                          child: Text(
                            "Income",
                            style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: trxnType == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      },
                      groupValue: trxnType,
                      onValueChanged: (value) {
                        setState(() {
                          trxnType = value;
                          selectedCategory = null;
                          selectedSubCategory = null;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          decoration: new BoxDecoration(
                              color: Color(0xFFefefef),
                              borderRadius: new BorderRadius.all(
                                Radius.circular(6.0),
                              )),
                          // width: 70,
                          margin: EdgeInsets.only(left: 16, top: 8),
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 4, bottom: 4),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      SizedBox(
                        width: 36,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: amountController,
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                hintText: "Amount",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                                // prefix: Text("₹ "),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () async {
                      hideKeyboard();
                      List<dynamic> selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySelection(
                                  categoryType: trxnType,
                                )),
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
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: 24,
                              height: 24,
                              decoration: new BoxDecoration(
                                  color: selectedCategory == null
                                      ? Color(0xFFefefef)
                                      : Colors.transparent,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              margin: EdgeInsets.only(left: 20, right: 10),
                              child: selectedCategory == null
                                  ? null
                                  : Icon(
                                      Icons.category,
                                      color: Colors.blue,
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
                                                  ' : ' +
                                                  selectedSubCategory
                                                      .subCategoryName
                                              : trxnType == 0
                                                  ? selectedCategory
                                                      .categoryName
                                                  : 'Income : ' +
                                                      selectedCategory
                                                          .categoryName
                                          : trxnType == 0
                                              ? 'Uncategorized'
                                              : 'Income',
                                      style: TextStyle(
                                          color: selectedCategory != null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.grey,
                                size: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 1,
                    ),
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
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: 24,
                              height: 24,
                              decoration: new BoxDecoration(
                                  color: selectedDate == null
                                      ? Color(0xFFefefef)
                                      : Colors.transparent,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              margin: EdgeInsets.only(left: 20, right: 10),
                              child: selectedDate == null
                                  ? null
                                  : Icon(
                                      Icons.today,
                                      color: Colors.blue,
                                    )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.all(8),
                                    child: Text(
                                      selectedDate != null
                                          ? DateFormat('dd MMM yyyy')
                                              .format(selectedDate)
                                          : 'Date',
                                      style: TextStyle(
                                          color: selectedDate != null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.grey,
                                size: 12,
                              ),
                            ),
                          )
                          // Container(
                          //     height: 40,
                          //     width: 40,
                          //     decoration: new BoxDecoration(
                          //         color: Colors.redAccent.withOpacity(0.9),
                          //         borderRadius: new BorderRadius.all(
                          //           Radius.circular(40.0),
                          //         )),
                          //     margin: EdgeInsets.all(12),
                          //     child: Icon(
                          //       Icons.filter_list,
                          //       color: Colors.white,
                          //     )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      hideKeyboard();
                      List<dynamic> selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySelection(
                                  categoryType: trxnType,
                                )),
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
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: 24,
                              height: 24,
                              decoration: new BoxDecoration(
                                  color: descriptionController.text.length == 0
                                      ? Color(0xFFefefef)
                                      : Colors.transparent,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              margin: EdgeInsets.only(left: 20, right: 10),
                              child: descriptionController.text.length == 0
                                  ? null
                                  : Icon(
                                      Icons.note,
                                      color: Colors.blue,
                                    )),
                          Expanded(
                            child: TextFormField(
                              maxLines: 3,
                              minLines: 1,
                              maxLength: 100,
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              onChanged: (text) {
                                if (text.length == 0 || text.length == 1) {
                                  setState(() {});
                                }
                              },
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                hintText: "Note",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                                // hasFloatingPlaceholder: true,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.grey,
                                size: 12,
                              ),
                            ),
                          )
                          // Container(
                          //     height: 40,
                          //     width: 40,
                          //     decoration: new BoxDecoration(
                          //         color: Colors.redAccent.withOpacity(0.9),
                          //         borderRadius: new BorderRadius.all(
                          //           Radius.circular(40.0),
                          //         )),
                          //     margin: EdgeInsets.all(12),
                          //     child: Icon(
                          //       Icons.filter_list,
                          //       color: Colors.white,
                          //     )),
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     hideKeyboard();
                  //     DateTime date = await showDatePicker(
                  //       context: context,
                  //       initialDate: DateTime.now(),
                  //       firstDate: DateTime(2000),
                  //       lastDate: DateTime(3000),
                  //     );
                  //     if (date != null) {
                  //       selectedDate = date;
                  //       setState(() {});
                  //     }
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: <Widget>[
                  //       Container(
                  //           width: 90,
                  //           margin: EdgeInsets.all(8),
                  //           child: Text(
                  //             'Date : ',
                  //             style: TextStyle(
                  //                 fontSize: 16, fontWeight: FontWeight.w500),
                  //           )),
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: <Widget>[
                  //             Container(
                  //                 margin: EdgeInsets.all(8),
                  //                 child: Text(
                  //                   DateFormat('dd-MM-yyyy')
                  //                       .format(selectedDate),
                  //                   style: TextStyle(
                  //                       color: Colors.blue,
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.w700),
                  //                 )),
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 border: Border(
                  //                   bottom: BorderSide(
                  //                       width: 1.0, color: Colors.grey),
                  //                 ),
                  //                 color: Colors.white,
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //           height: 40,
                  //           width: 40,
                  //           decoration: new BoxDecoration(
                  //               color: Colors.blue,
                  //               borderRadius: new BorderRadius.all(
                  //                 Radius.circular(40.0),
                  //               )),
                  //           margin: EdgeInsets.all(12),
                  //           child: Icon(
                  //             Icons.date_range,
                  //             color: Colors.white,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     Container(
                  //         width: 90,
                  //         margin: EdgeInsets.all(8),
                  //         child: Text(
                  //           'Amount : ',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         )),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           TextFormField(
                  //             controller: amountController,
                  //             style: new TextStyle(
                  //                 color: Colors.blue,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w700),
                  //             decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.symmetric(
                  //                 horizontal: 8.0,
                  //                 vertical: 10.0,
                  //               ),
                  //               hintText: "Amount",
                  //               hintStyle: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //               ),
                  //               prefix: Text("₹ "),
                  //               prefixStyle: new TextStyle(
                  //                   color: Colors.blue,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.w700),
                  //               hasFloatingPlaceholder: true,
                  //               filled: true,
                  //               fillColor: Colors.transparent,
                  //             ),
                  //             keyboardType: TextInputType.numberWithOptions(
                  //                 decimal: true),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     Container(
                  //         height: 40,
                  //         width: 40,
                  //         decoration: new BoxDecoration(
                  //             color: Colors.green.withOpacity(0.9),
                  //             borderRadius: new BorderRadius.all(
                  //               Radius.circular(40.0),
                  //             )),
                  //         margin: EdgeInsets.all(12),
                  //         child: Icon(
                  //           Icons.attach_money,
                  //           color: Colors.white,
                  //         )),
                  //   ],
                  // ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     hideKeyboard();
                  //     List<dynamic> selected = await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => CategorySelection(
                  //                 categoryType: trxnType,
                  //               )),
                  //     );
                  //     if (selected != null) {
                  //       selectedCategory = selected[0];
                  //       if (selected.length > 1) {
                  //         selectedSubCategory = selected[1];
                  //       } else {
                  //         selectedSubCategory = null;
                  //       }
                  //     }
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: <Widget>[
                  //       Container(
                  //           width: 90,
                  //           margin: EdgeInsets.all(8),
                  //           child: Text(
                  //             'Category: ',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           )),
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: <Widget>[
                  //             Container(
                  //                 margin: EdgeInsets.all(8),
                  //                 child: Text(
                  //                   selectedCategory != null
                  //                       ? selectedSubCategory != null
                  //                           ? selectedCategory.categoryName +
                  //                               ' : ' +
                  //                               selectedSubCategory
                  //                                   .subCategoryName
                  //                           : trxnType == 0
                  //                               ? selectedCategory.categoryName
                  //                               : 'Income : ' +
                  //                                   selectedCategory
                  //                                       .categoryName
                  //                       : trxnType == 0
                  //                           ? 'Uncategorized'
                  //                           : 'Income',
                  //                   style: TextStyle(
                  //                       color: Colors.blue,
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.w700),
                  //                 )),
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                 border: Border(
                  //                   bottom: BorderSide(
                  //                       width: 1.0, color: Colors.grey),
                  //                 ),
                  //                 color: Colors.white,
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //           height: 40,
                  //           width: 40,
                  //           decoration: new BoxDecoration(
                  //               color: Colors.redAccent.withOpacity(0.9),
                  //               borderRadius: new BorderRadius.all(
                  //                 Radius.circular(40.0),
                  //               )),
                  //           margin: EdgeInsets.all(12),
                  //           child: Icon(
                  //             Icons.filter_list,
                  //             color: Colors.white,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     Container(
                  //         width: 90,
                  //         margin: EdgeInsets.all(8),
                  //         child: Text(
                  //           'Description : ',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         )),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: <Widget>[
                  //           TextFormField(
                  //             maxLines: 3,
                  //             controller: descriptionController,
                  //             style: new TextStyle(
                  //                 color: Colors.blue,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w700),
                  //             decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.symmetric(
                  //                 horizontal: 8.0,
                  //                 vertical: 10.0,
                  //               ),
                  //               hintText: "Description",
                  //               hintStyle: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //               ),
                  //               // prefix: Text("₹ "),
                  //               prefixStyle: new TextStyle(
                  //                   color: Colors.blue,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.w700),
                  //               hasFloatingPlaceholder: true,
                  //               filled: true,
                  //               fillColor: Colors.transparent,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     Container(
                  //         height: 40,
                  //         width: 40,
                  //         decoration: new BoxDecoration(
                  //             color: Colors.grey.withOpacity(0.9),
                  //             borderRadius: new BorderRadius.all(
                  //               Radius.circular(40.0),
                  //             )),
                  //         margin: EdgeInsets.all(12),
                  //         child: Icon(
                  //           Icons.description,
                  //           color: Colors.white,
                  //         )),
                  //   ],
                  // ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.blue.withOpacity(0.5),
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      hideKeyboard();

                      if (amountController.text.length == 0) {
                        showAlert(context, "An amount is required.");
                        return;
                      }

                      if (!RegExp(
                              r"^\-?\(?\$?\s*\-?\s*\(?(((\d{1,3}((\,\d{3})*|\d*))?(\.\d{1,4})?)|((\d{1,3}((\,\d{3})*|\d*))(\.\d{0,4})?))\)?$")
                          .hasMatch(amountController.text)) {
                        showAlert(context, "Please enter a valid amount.");
                        return null;
                      }

                      if (int.parse(amountController.text) <= 0) {
                        showAlert(context, "Please enter a valid amount.");
                        return null;
                      }
                      if (selectedCategory == null) {
                        showAlert(context, "Please select Category.");
                        return;
                      }

                      if (selectedDate == null) {
                        showAlert(context, "Please select Date.");
                        return;
                      }

                      if (descriptionController.text.length == 0) {
                        showAlert(context, "Please enter a Note.");
                        return;
                      }

                      TransactionModel trxnModel = new TransactionModel(
                          int.parse(amountController.text),
                          DateFormat('dd-MM-yyyy').format(selectedDate),
                          selectedCategory != null
                              ? selectedCategory.categoryId
                              : -1,
                          selectedSubCategory != null
                              ? selectedSubCategory.subCategoryId
                              : -1,
                          descriptionController.text,
                          '',
                          DateFormat('dd-MM-yyyy').format(selectedDate));

                      int value =
                          await databaseHelper.saveTransaction(trxnModel);
                      if (value != 0) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 70),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
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
