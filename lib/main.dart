import 'package:flutter/material.dart';
import 'package:Sigelo/Vistas/home.dart';

void main() {
  runApp(MyApp());
}

List productos;


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sigelo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Sigelo'),
    );
  }
}

