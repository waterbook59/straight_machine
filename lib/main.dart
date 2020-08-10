
import 'package:flutter/material.dart';
import 'package:straightmachine/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ツッコミマシーン",
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
