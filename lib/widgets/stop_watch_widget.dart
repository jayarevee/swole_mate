import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swole_mate/widgets/resusable_card.dart';
import 'package:swole_mate/widgets/round_icon_button.dart';

import '../constants.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> with TickerProviderStateMixin {
  late AnimationController controller;
  int _time = 0;
  bool isPlaying = false;
  IconData watchPlayIcon = FontAwesomeIcons.play;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(hours: 1));
    super.initState();
  }

  String get timerText {
    Duration time = controller.duration! * controller.value;
    if (controller.value == 0.0) {
      return '${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${(time.inMinutes % 60).toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void startTimer() {
    controller.forward(from: controller.value == 1.0 ? 0 : controller.value);
    isPlaying = true;
  }

  void pauseTimer() {
    controller.stop();
    isPlaying = false;
  }

  void togglePlayIcon() {
    setState(() {
      watchPlayIcon =
          isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play;
    });
  }

  void resetWatch() {
    setState(() {
      controller.reset();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      function: () {},
      color: kWidgetColor,
      cardChild: Column(
        children: [
          Text(
            'STOPWATCH',
            style: TextStyle(color: Colors.white),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Text(
              timerText,
              style: kTimeTextStyle,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RoundIconButton(
              onPress: () {
                if (isPlaying) {
                  pauseTimer();
                } else {
                  startTimer();
                }
                togglePlayIcon();
              },
              icon: watchPlayIcon,
            ),
            RoundIconButton(
                icon: FontAwesomeIcons.redo,
                onPress: () {
                  if (!isPlaying) {
                    resetWatch();
                  }
                })
          ])
        ],
      ),
    );
  }
}
