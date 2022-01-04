import 'package:flutter/material.dart';
import 'package:swole_mate/widgets/clock_widget.dart';
import 'package:swole_mate/widgets/spotify_widget.dart';
import 'package:swole_mate/widgets/stop_watch_widget.dart';
import 'package:swole_mate/widgets/timer_widget.dart';

import '../constants.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: ClockWidget()),
              ],
            ),
            Row(
              children: [
                Expanded(child: TimerWidget()),
                Expanded(child: StopWatch())
              ],
            ),
            Row(
              children: [
                Expanded(child: SpotifyWidget()),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
        ));
  }
}
