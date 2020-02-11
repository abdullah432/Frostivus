import 'package:flutter/material.dart';
import 'package:frostivus/screens/orderlist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frostivus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderList(),
      // home: MyHomePage(title: 'Frostivus'),
    );
  }
}