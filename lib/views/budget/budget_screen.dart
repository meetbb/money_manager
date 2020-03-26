import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/budget_model.dart';
import 'package:moneymanager/utlis/asset_utils.dart';
import 'package:moneymanager/views/budget/add_budget_screen.dart';
import 'package:moneymanager/views/uiwidgets/category_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BudgetScreenState();
  }
}

class BudgetScreenState extends State<BudgetScreen> {
  final budgetListBloc = BudgetListBloc();

  @override
  void initState() {
    super.initState();
    getBudget();
  }

  @override
  void dispose() {
    super.dispose();
    budgetListBloc.dispose();
  }

  void getBudget() async {
    var dbHelper = new DatabaseHelper();
    List<BudgetModel> modelList = await dbHelper.getBudgetData();
    budgetListBloc.updateModelList(modelList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBudgetScreen()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(75),
                        bottomRight: Radius.circular(75),
                      ),
                      color: Colors.blue[700],
                    ),
                    child: Center(
                      child: CircularPercentIndicator(
                        radius: 200.0,
                        lineWidth: 10.0,
                        percent: 0.8,
                        center: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.monetization_on,
                                size: 40.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: new Text(
                                  "₹ 250",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 32),
                                ),
                              ),
                              new Text(
                                "Left to spend",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        backgroundColor: Colors.white54,
                        progressColor: Colors.white,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                  ),
                  new Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 50,
                    left: 15,
                    right: 15,
                    bottom: 0,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Card(
                                  margin: new EdgeInsets.only(
                                      top: 10, left: 10, right: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(
                                          'March 2020',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Container(
                                          width: 60,
                                          height: 1,
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                DescText(
                                                    labelValue: 'Projection'),
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                ValueText(
                                                  text: '₹ 25,000',
                                                  fontWeight: FontWeight.w500,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                DescText(
                                                    labelValue: 'Daily Budget'),
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                ValueText(
                                                  text: '₹ 1000',
                                                  fontWeight: FontWeight.w500,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                DescText(
                                                    labelValue: 'Total spent'),
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                ValueText(
                                                  text: '₹ 250',
                                                  fontWeight: FontWeight.w500,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child:
                                      HeaderText(text: 'BUDGET DISTRIBUTION'),
                                ),
                                StreamBuilder<List<BudgetModel>>(
                                    stream: budgetListBloc.budgetListStream,
                                    builder: (context, snapshot) {
                                      List<BudgetModel> budgetList = new List();
                                      List<String> iconList = new List();
                                      if (snapshot.hasData) {
                                        budgetList = snapshot.data;
                                        for (var budgetModel in budgetList) {
                                          switch (
                                              budgetModel.getBudgetCategory) {
                                            case "HomeExpense":
                                              iconList
                                                  .add(AssetUtils.HOME_WIDGET);
                                              break;
                                            case "Food":
                                              iconList
                                                  .add(AssetUtils.FOOD_WIDGET);
                                              break;
                                            case "Rent":
                                              iconList
                                                  .add(AssetUtils.RENT_WIDGET);
                                              break;
                                            case "Salary":
                                              iconList.add(
                                                  AssetUtils.SALARY_WIDGET);
                                              break;
                                            case "Shopping":
                                              iconList.add(
                                                  AssetUtils.SHOPPING_WIDGET);
                                              break;
                                            default:
                                              iconList
                                                  .add(AssetUtils.HOME_WIDGET);
                                          }
                                        }
                                      }
                                      return GridView.builder(
                                          itemCount: budgetList.length,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Card(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                CategoryWidget(
                                                  iconName: iconList[index],
                                                  padding: 8.0,
                                                  size: 50,
                                                  iconSize: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: ValueText(
                                                    text:
                                                        '₹ ${budgetList[index].getBudgetAmount}',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              ],
                                            ));
                                          });
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetListBloc {
  StreamController<List<BudgetModel>> controller =
      new StreamController<List<BudgetModel>>.broadcast();

  void updateModelList(List<BudgetModel> counter) {
    controller.sink.add(counter);
  }

  void dispose() {
    controller.close();
  }

  Stream get budgetListStream => controller.stream;
}

class DescText extends StatelessWidget {
  final String labelValue;

  DescText({@required this.labelValue});

  @override
  Widget build(BuildContext context) {
    return Text(
      labelValue,
      style: TextStyle(
          color: Colors.grey[400], fontWeight: FontWeight.w400, fontSize: 16),
    );
  }
}

class ValueText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;

  ValueText(
      {@required this.text,
      this.fontWeight = FontWeight.w600,
      this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black87, fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  final Color fontColor;

  HeaderText({@required this.text, this.fontColor = Colors.black87});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: this.fontColor, fontWeight: FontWeight.w400, fontSize: 19),
    );
  }
}
