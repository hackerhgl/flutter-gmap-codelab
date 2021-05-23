import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/map.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        '/map': (_) => MapScreen(),
      },
    );
  }
}
