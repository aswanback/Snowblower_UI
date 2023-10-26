import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ui_463/helpers/provider.dart';
import 'package:ui_463/helpers/weather.dart';
import 'package:ui_463/live_view.dart';
import 'package:location/location.dart';

import 'helpers/location.dart';

class Home extends StatefulWidget {
  final GlobalKey tabkey;
  const Home({
    super.key,
    required this.tabkey,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weather',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    WeatherPage(lat: 40.433273, lon: -86.913523),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                final BottomNavigationBar navigationBar =
                    widget.tabkey.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(1);
              },
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Scheduled Clear',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Consumer<AppData>(
                        builder: (context, data, child) =>
                            data.scheduledClearTime != null
                                ? Text(
                                    DateFormat('EEEE h:m a')
                                        .format(
                                            data.scheduledClearTime!.toLocal())
                                        .toString(),
                                    style: TextStyle(fontSize: 16),
                                  )
                                : Text(
                                    'No upcoming clear',
                                    style: TextStyle(fontSize: 16),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                final BottomNavigationBar navigationBar =
                    widget.tabkey.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(3);
              },
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live View',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                          height: 130,
                          child: LiveLocationMap(
                            key: UniqueKey(),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
