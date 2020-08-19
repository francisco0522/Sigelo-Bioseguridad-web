import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../Vistas/home.dart';
import 'package:Sigelo/Vistas/login.dart';

class FluroRouter {
  static Router router = Router();
  static Handler _home = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MyHomePage());
  static Handler _inicio = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());
  static void setupRouter() {
    router.define(
      '/',
      handler: _home,
    );
    router.define(
      '/inicio',
      handler: _inicio,
    );
  }
}