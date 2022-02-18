import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swole_mate/widgets/resusable_card.dart';
import 'package:swole_mate/widgets/round_icon_button.dart';

import '../constants.dart';

class TimerWidget extends StatefulWidget {
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  final AudioCache _audioCache = AudioCache();
  late AnimationController controller;
  late int _time;
  bool isPlaying = false;
  IconData startTimerIcon = FontAwesomeIcons.play;
  @override
  void initState() {
    _time = 180;
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: _time));
    controller.addListener(() {
      whenTimerDone();
      if (controller.isAnimating) {
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  String get timerText {
    Duration time = controller.duration! * controller.value;
    if (controller.value == 0.0) {
      return '${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${(time.inMinutes % 60).toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void startTimer() {
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    isPlaying = true;
  }

  void pauseTimer() {
    controller.stop();
    isPlaying = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void increaseTime() {
    int increasedTime = _time + 5;
    if (!isPlaying) {
      setState(() {
        _time = increasedTime > 600 ? _time : increasedTime;
        controller.duration = Duration(seconds: _time);
      });
    }
  }

  void decreaseTime() {
    int decreasedTime = _time - 5;
    if (!isPlaying) {
      setState(() {
        _time = decreasedTime <= 0 ? _time : decreasedTime;
        controller.duration = Duration(seconds: _time);
      });
    }
  }

  void togglePlayIcon() {
    setState(() {
      startTimerIcon =
          isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play;
    });
  }

  void whenTimerDone() {
    if (timerText == '00:00') {
      _audioCache.play('audio/alarm.wav');
      isPlaying = false;
      togglePlayIcon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      cardChild:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          'TIMER',
          style: TextStyle(color: Colors.white),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Text(
            timerText,
            style: kTimeTextStyle,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundIconButton(
              onPress: () {
                decreaseTime();
              },
              icon: FontAwesomeIcons.minus,
            ),
            RoundIconButton(
              onPress: () {
                if (isPlaying) {
                  pauseTimer();
                } else {
                  startTimer();
                }
                togglePlayIcon();
              },
              icon: startTimerIcon,
            ),
            RoundIconButton(
              onPress: () {
                increaseTime();
              },
              icon: FontAwesomeIcons.plus,
            ),
          ],
        )
      ]),
      function: () {},
      color: Color(0xFF1D1D1D),
    );
  }
}

// TimerBuilder.scheduled([_alertTime], builder: (context) {})
