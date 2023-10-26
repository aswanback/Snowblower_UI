import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_463/home.dart';
import 'package:ui_463/control.dart';
import 'package:ui_463/live_view.dart';
import 'package:ui_463/schedule.dart';
import 'package:ui_463/settings.dart';
import 'package:web_socket_channel/io.dart';
import 'helpers/provider.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});
  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  static GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late IOWebSocketChannel _channel;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    _channel = IOWebSocketChannel.connect(
        'ws://192.168.1.34:8765', // 'ws://192.168.1.27:8765',
        pingInterval: Duration(seconds: 5));
    _subscription = _channel.stream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void _onData(dynamic data) {
    print(data);
  }

  void _onError(dynamic error) {
    print('WebSocket error: $error');
    _reconnect();
  }

  void _onDone() {
    print('WebSocket done');
    _reconnect();
  }

  void _reconnect() {
    _subscription.cancel();
    _channel.sink.close();
    Timer(Duration(seconds: 2), () {
      _connect();
    });
  }

  void _sendMessage() {
    print('Sending message...');
    final json = {'message': 'Hello, WebSocket!'};
    _channel.sink.add(jsonEncode(json));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 50,
        title: Text(
          'Snowbotics',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: <Widget>[
            Home(tabkey: globalKey),
            Schedule(socket: _channel),
            Control(socket: _channel),
            const LiveView(),
            Settings(socket: _channel),
          ].elementAt(_selectedIndex),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        key: globalKey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlueAccent[700],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gamecontroller_fill),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_outlined),
            label: 'Live View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _channel.sink.close();
    super.dispose();
  }
}
