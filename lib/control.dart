import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Control extends StatefulWidget {
  final WebSocketChannel socket;
  const Control({super.key, required this.socket});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  bool driveInProgress = false;
  bool blowInProgress = false;

  final List<IconData?> driveGrid = [
    null,
    Icons.arrow_upward,
    null,
    Icons.arrow_back,
    Icons.play_arrow,
    Icons.arrow_forward,
    null,
    Icons.arrow_downward,
    null
  ];

  final List<IconData?> blowGrid = [
    null,
    null,
    null,
    Icons.rotate_left,
    Icons.play_arrow,
    Icons.rotate_right,
    null,
    null,
    null
  ];

  void bruh() {}

  void sendMessage(json) {
    final jsonfinal = {'control': json};
    widget.socket.sink.add(jsonEncode(jsonfinal));
  }

  void sendForward(bool on) {
    sendMessage({'forward': on});
  }

  void sendBackward(bool on) {
    sendMessage({'backward': on});
  }

  void sendLeft(bool on) {
    sendMessage({'left': on});
  }

  void sendRight(bool on) {
    sendMessage({'right': on});
  }

  void sendOn(bool on) {
    sendMessage({'on': on});
  }

  void sendChuteLeft(bool on) {
    sendMessage({'chute_left': on});
  }

  void sendChuteRight(bool on) {
    sendMessage({'chute_right': on});
  }

  void sendAugerOn(bool on) {
    sendMessage({'auger_on': on});
  }

  @override
  Widget build(BuildContext context) {
    List<void Function()?> onPressedDrive = [
      null,
      () {
        sendForward(true);
      },
      null,
      () {
        sendLeft(true);
      },
      () {
        sendOn(!driveInProgress);
        setState(() {
          driveInProgress = !driveInProgress;
        });
      },
      () {
        sendRight(true);
      },
      null,
      () {
        sendBackward(true);
      },
      null,
    ];

    List<void Function()?> onReleasedDrive = [
      null,
      () {
        sendForward(false);
      },
      null,
      () {
        sendLeft(false);
      },
      null,
      () {
        sendRight(false);
      },
      null,
      () {
        sendBackward(false);
      },
      null,
    ];

    List<void Function()?> onPressedBlow = [
      null,
      null,
      null,
      () {
        sendChuteLeft(true);
      },
      () {
        sendAugerOn(!blowInProgress);
        setState(() {
          blowInProgress = !blowInProgress;
        });
      },
      () {
        sendChuteRight(true);
      },
      null,
      null,
      null
    ];

    List<void Function()?> onReleasedBlow = [
      null,
      null,
      null,
      () {
        sendChuteLeft(false);
      },
      null,
      () {
        sendChuteRight(false);
      },
      null,
      null,
      null
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RotatedBox(
            quarterTurns: 1,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Driving',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 20,
                ),
                IconGrid(
                  icons: driveGrid,
                  onPressed: onPressedDrive,
                  onReleased: onReleasedDrive,
                  centerState: driveInProgress,
                ),
              ],
            )),
        const SizedBox(
          height: 50,
        ),
        RotatedBox(
            quarterTurns: 1,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Blowing',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 20,
                ),
                IconGrid(
                  icons: blowGrid,
                  onPressed: onPressedBlow,
                  centerState: blowInProgress,
                  onReleased: onReleasedBlow,
                ),
              ],
            )),
      ],
    );
  }
}

class IconGrid extends StatelessWidget {
  final List<IconData?> icons;
  final List<void Function()?> onPressed;
  final List<void Function()?> onReleased;
  final bool? centerState;

  const IconGrid(
      {super.key,
      required this.icons,
      required this.onPressed,
      this.centerState,
      required this.onReleased});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControlIcon(
                icon: icons[0],
                onPressed: onPressed[0],
                onReleased: onReleased[0],
              ),
              ControlIcon(
                icon: icons[1],
                onPressed: onPressed[1],
                onReleased: onReleased[1],
              ),
              ControlIcon(
                icon: icons[2],
                onPressed: onPressed[2],
                onReleased: onReleased[2],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControlIcon(
                icon: icons[3],
                onPressed: onPressed[3],
                onReleased: onReleased[3],
              ),
              ControlIcon(
                icon: icons[4],
                onPressed: onPressed[4],
                onReleased: onReleased[4],
                centerState: centerState,
              ),
              ControlIcon(
                icon: icons[5],
                onPressed: onPressed[5],
                onReleased: onReleased[5],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControlIcon(
                icon: icons[6],
                onPressed: onPressed[6],
                onReleased: onReleased[6],
              ),
              ControlIcon(
                icon: icons[7],
                onPressed: onPressed[7],
                onReleased: onReleased[7],
              ),
              ControlIcon(
                icon: icons[8],
                onPressed: onPressed[8],
                onReleased: onReleased[8],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlIcon extends StatelessWidget {
  IconData? icon;
  final void Function()? onPressed;
  final void Function()? onReleased;
  final bool? centerState;
  ControlIcon(
      {super.key,
      required this.icon,
      this.onPressed,
      this.centerState,
      this.onReleased});

  void bruh() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        color: icon != null ? Colors.grey[100] : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          child: GestureDetector(
            onLongPress: onPressed,
            onLongPressUp: onReleased,
            child: IconButton(
              splashRadius: 1,
              onPressed: bruh,
              icon: Icon(centerState != null
                  ? (centerState! ? Icons.stop : Icons.play_arrow)
                  : icon),
              iconSize: 55,
              disabledColor: Colors.grey,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
