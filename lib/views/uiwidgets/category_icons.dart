import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShoppingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'assets/shopping.svg',
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}

class SalaryWidget extends StatelessWidget {
  final double size;
  final double iconSize;
  final double padding;

  SalaryWidget({this.size = 40, this.iconSize = 25, this.padding = 5.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SvgPicture.asset(
          'assets/salary.svg',
          width: iconSize,
          height: iconSize,
        ),
      ),
    );
  }
}

class FoodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.deepOrange[300],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'assets/food.svg',
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'assets/home.svg',
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}

class RentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber[800],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'assets/rent.svg',
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}
