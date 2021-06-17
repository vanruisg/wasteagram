import 'package:flutter/material.dart';
import 'package:wasteagram/screens/homepage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData.dark(),
      home: const Homepage(),
    );
  }
}
