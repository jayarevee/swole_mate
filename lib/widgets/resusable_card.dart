import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {required this.color, required this.cardChild, required this.function});
  final Color color;
  final Widget cardChild;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
    );
  }
}
// height: MediaQuery.of(context).size.height * 0.2,
// width: MediaQuery.of(context).size.width * 0.1,
