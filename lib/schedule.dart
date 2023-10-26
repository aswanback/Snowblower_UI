import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ui_463/helpers/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Schedule extends StatefulWidget {
  final WebSocketChannel socket;
  const Schedule({super.key, required this.socket});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool now = false;
  bool auto = false;
  bool time = false;
  bool loading = false;

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime datetime = DateTime.now();
  int interval = 1;
  int numTimes = 1;
  bool repeat = false;

  void sendMessage(json) {
    widget.socket.sink.add(jsonEncode(json));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                int nowInSeconds =
                    DateTime.now().millisecondsSinceEpoch ~/ 1000;
                final json = {'schedule': nowInSeconds};
                sendMessage(json);
                setState(() {
                  now = true;
                  loading = true;
                  time = auto = false;
                });
                Timer(const Duration(seconds: 1), () {
                  setState(() {
                    loading = false;
                  });
                });
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.not_started_outlined,
                      size: 40,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Clear Now",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Start clearing snow now",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    now
                        ? (loading
                            ? const CupertinoActivityIndicator()
                            : const Icon(Icons.check))
                        : const Icon(null),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  time = true;
                  loading = true;
                  now = auto = false;
                });
                _modal(context);
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 40,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Scheduled Clear",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Pick a time to clear snow",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Consumer<AppData>(
                      builder: (context, data, child) => data
                                  .scheduledClearTime !=
                              null
                          ? Text(
                              'Next Clear: ${DateFormat('EEEE h:m a').format(data.scheduledClearTime!.toLocal()).toString()}')
                          : const Text('Nothing scheduled'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  auto = true;
                  loading = true;
                  now = time = false;
                });
                Timer(const Duration(seconds: 1), () {
                  setState(() {
                    loading = false;
                  });
                });
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.ac_unit_sharp,
                      size: 40,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Auto-schedule",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Clear when the weather shows snow",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    auto
                        ? (loading
                            ? const CupertinoActivityIndicator()
                            : const Icon(Icons.check))
                        : const Icon(null),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _modal(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      sendMessage({
                        'schedule': datetime.millisecondsSinceEpoch ~/ 1000
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 500,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "Select Time",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200.0,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            datetime = newDateTime;
                            selectedTime = TimeOfDay.fromDateTime(newDateTime);
                            Provider.of<AppData>(context, listen: false)
                                .setScheduledClearTime(newDateTime);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Repetition"),
                          CupertinoSwitch(
                            value: repeat,
                            onChanged: (value) {
                              setState(() {
                                repeat = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    repeat
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Re-clear every"),
                                SizedBox(
                                  height: 100,
                                  width: 60,
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        interval = index + 1;
                                      });
                                    },
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: 0),
                                    children: List.generate(6, (index) {
                                      return Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const Text("hours,"),
                                SizedBox(
                                  height: 100,
                                  width: 60,
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        interval = index + 1;
                                      });
                                    },
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: 0),
                                    children: List.generate(6, (index) {
                                      return Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const Text("times"),
                              ],
                            ),
                          )
                        : const SizedBox(
                            height: 50,
                          ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
