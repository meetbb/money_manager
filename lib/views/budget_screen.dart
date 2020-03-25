import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BudgetScreenState();
  }
}

class BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                          bottomRight: Radius.circular(75)),
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
                                Icons.home,
                                size: 40.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: new Text(
                                  "₹ 250",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 32),
                                ),
                              ),
                              new Text(
                                "Left to spend",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          DescText(labelValue: 'Projection'),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          ValueText(text: '₹ 25,000')
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          DescText(labelValue: 'Daily Budget'),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          ValueText(text: '₹ 1000')
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          DescText(labelValue: 'Total spent'),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          ValueText(text: '₹ 250')
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: HeaderText(text: 'BUDGET DISTRIBUTION'),
                          ),
                          GridView.builder(
                              itemCount: 9,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return new Card(
                                    child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                      'assets/shopping.svg',
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                ));
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
    );
  }
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

  ValueText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 19),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;

  HeaderText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 19),
    );
  }
}

