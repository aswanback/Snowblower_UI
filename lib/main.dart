import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_463/register.dart';
import 'helpers/provider.dart';
import 'login.dart';
import 'tabs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final channel;

  @override
  void initState() {
    super.initState();
    final channel =
        WebSocketChannel.connect(Uri.parse('ws://your-websocket-url'));
  }

  // @override
  // void dispose() {
  //   channel.sink.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      builder: (context, _) => MaterialApp(
        routes: {
          '/': (context) => const Login(),
          '/create_account': (context) => const Register(),
          '/home': (context) => const Tabs(),
        },
        theme: ThemeData(
          fontFamily: 'Georgia',
          primaryColor: const Color.fromARGB(255, 160, 228, 255),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            background: Colors.lightBlueAccent,
            onBackground: Colors.white70,
            primary: Colors.white, //.fromARGB(255, 160, 228, 255),
            onPrimary: Colors.black54,
            secondary: Color.fromARGB(255, 184, 227, 244),
            onSecondary: Colors.black54,
            error: Colors.red,
            onError: Colors.black,
            surface: Color.fromARGB(255, 12, 84, 118),
            onSurface: Color.fromARGB(255, 224, 224, 224),
          ),
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Hind'),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            titleMedium: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            bodySmall: TextStyle(fontSize: 10.0, fontFamily: 'Hind'),
          ),
        ),
      ),
    );
  }
}
