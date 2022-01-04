import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swole_mate/widgets/resusable_card.dart';
import 'package:timer_builder/timer_builder.dart';

import '../constants.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({Key? key}) : super(key: key);

  String getTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('Hms');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      cardChild: Column(
        children: [
          Text(
            'CLOCK',
            style: TextStyle(color: Colors.white),
          ),
          TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
            return Text(
              getTime(),
              style: kTimeTextStyle,
            );
          }),
        ],
      ),
      function: () {},
      color: kWidgetColor,
    );
  }
}
