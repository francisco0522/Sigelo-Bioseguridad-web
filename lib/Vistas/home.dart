import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';


import 'package:Sigelo/Vistas/registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeLogin.dart';
import 'homeProveedor.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/inicio': (context) => LoginPage(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/registro': (context) => RegistroPage(),
    },
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Image pic = new Image.memory(base64Decode('apiNodeJs/uploads/userFile-1595962301791'));

  SharedPreferences sharedPreferences;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") != null){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageLogin()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return web();
        }
        return mobile();
      },
    );
  }

  widgetLogo() {
    return Container(
        margin: const EdgeInsets.only(right: 30.0),
        width: 110.0,
        height: 30.0,
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/logo.png"),
                fit: BoxFit.fill)));
  }

  List<String> fotos = [
    'assets/images/promo1.jpg',
    'assets/images/promo2.png',
    'assets/images/promo3.jpg',
  ];

//-------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------        Web Part              ---------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------

  web() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: appBarWeb(),
      ),
      body: widgetBodyWeb(),
    );
  }

  appBarWeb() {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          Row(children: <Widget>[
            widgetLogo(),
            widgetSearchBar(),
          ]),
          Row(children: <Widget>[
            widgetRegistrar(),
            widgetIniciarSesion(),
          ])
        ]));
  }

  Widget widgetSearchBar() {
    return Container(
      padding:
          const EdgeInsets.only(left: 30.0, top: 3.0, bottom: 3.0, right: 10.0),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(179, 179, 179, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ), //       <--- BoxDecoration here
      child: new InkWell(
          onTap: () {},
          child: Row(children: <Widget>[
            Text(
              "Buscar productos de bioseguridad                                       ",
              style: TextStyle(
                  fontSize: 15.0, color: Color.fromRGBO(179, 179, 179, 1)),
            ),
            Icon(
              Icons.search,
              color: Color.fromRGBO(179, 179, 179, 1),
              size: 30.0,
            ),
          ])),
    );
  }

  Widget widgetRegistrar() {
    return Container(
      padding: const EdgeInsets.only(
          left: 30.0, top: 10.0, bottom: 10.0, right: 30.0),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
        color: Color.fromRGBO(179, 179, 179, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Color.fromRGBO(179, 179, 179, 1),
      ), //       <--- BoxDecoration here
      child: new InkWell(
        onTap: () {
           Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroPage()),
                  );
        },
        child: Text(
          "Regístrate",
          style: TextStyle(fontSize: 15.0, color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget widgetIniciarSesion() {
    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
      margin: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Color.fromRGBO(179, 179, 179, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Color.fromRGBO(179, 179, 179, 1),
      ), //       <--- BoxDecoration here
      child: new InkWell(
        onTap: () {
          Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage()),
                  );
        },
        child: Text(
          "Iniciar Sesión",
          style: TextStyle(fontSize: 15.0, color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  widgetBodyWeb() {
    return ListView(children: <Widget>[
      widgetCarousel(),
      widgetInfo(),
    ]);
  }

  widgetCarousel() {
    return Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        decoration: new BoxDecoration(color: Color.fromRGBO(188, 35, 35, 1)),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 400.0,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          items: fotos
              .map((item) => Container(
                    child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage(item)),
              ),
            ),
                  ))
              .toList(),
        ));
  }

  widgetInfo() {
    return Container(
        child: Column(children: <Widget>[
      Row(children: <Widget>[
        Expanded(
            child: Container(
                margin: const EdgeInsets.all(50.0),
                height: 400.0,
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/bio.jpg"),
                        fit: BoxFit.fill)))),
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(50.0),
          height: 400.0,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            image: new DecorationImage(
                image: new AssetImage("assets/images/salud.jpg"),
                fit: BoxFit.fill),
          ),
        ))
      ]),
      Row(children: <Widget>[
        Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Lorem ipsum",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '\n\n Lorem ipsum dolor sit amet consectetur adipiscing elit mi, penatibus montes placerat class nascetur pellentesque euismod ut eu, dictumst eros ad nec pharetra ...',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ))),
        Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Lorem ipsum",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '\n\n Lorem ipsum dolor sit amet consectetur adipiscing elit mi, penatibus montes placerat class nascetur pellentesque euismod ut eu, dictumst eros ad nec pharetra ...',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ))),
             Expanded(
            child: Container(
          margin: const EdgeInsets.all(50.0),
          height: 400.0,
             child: SizedBox(
          width: 150,
          child: pic,
        )
        ))
      ]),
    ]));
  }

//-------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------        Mobile Part              ---------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------------

  mobile() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: appBarMobile(),
        iconTheme: new IconThemeData(color: Color.fromRGBO(179, 179, 179, 1)),
      ),
      body: widgetBodyMobile(),
      drawer: Drawer(
        child: widgetMenuLateral(),
      ),
    );
  }

  appBarMobile() {
    return Container(
        child: Row(children: <Widget>[
      widgetLogo(),
      widgetSearchIcon(),
    ]));
  }

  widgetSearchIcon() {
    return Container(
        margin: const EdgeInsets.only(left: 100.0),
        child: Icon(
          Icons.search,
          color: Color.fromRGBO(179, 179, 179, 1),
          size: 30.0,
        ));
  }

  Widget widgetMenuLateral() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
            image: new AssetImage("assets/images/logo.png"),
          ))),
          decoration: BoxDecoration(
            color: Color.fromRGBO(179, 179, 179, 1),
          ),
        ),
        ListTile(
          title: Text('Registrarse'),
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroPage()),
                  );
          },
        ),
        ListTile(
          title: Text('Iniciar Sesión'),
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage()),
                  );
          },
        ),
      ],
    );
  }

  widgetBodyMobile() {
    return ListView(children: <Widget>[
      widgetCarouselMobile(),
      widgetInfoMobile(),
    ]);
  }

  widgetCarouselMobile() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: fotos.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage(item), fit: BoxFit.fill),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  widgetInfoMobile() {
    return Column(children: <Widget>[
       Container(
              margin: const EdgeInsets.all(30.0),
              height: 150.0,
              decoration: new BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  image: new DecorationImage(
                      image: new AssetImage("assets/images/bio.jpg"),
                      fit: BoxFit.fill))),
      Container(
            margin: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Lorem ipsum",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '\n\n Lorem ipsum dolor sit amet consectetur adipiscing elit mi, penatibus montes placerat class nascetur pellentesque euismod ut eu, dictumst eros ad nec pharetra ...',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )),
     Container(
        margin: const EdgeInsets.all(30.0),
        height: 150.0,
        decoration: new BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          image: new DecorationImage(
              image: new AssetImage("assets/images/salud.jpg"),
              fit: BoxFit.fill),
        ),
      ),
       Container(
              margin: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Lorem ipsum",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '\n\n Lorem ipsum dolor sit amet consectetur adipiscing elit mi, penatibus montes placerat class nascetur pellentesque euismod ut eu, dictumst eros ad nec pharetra ...',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )),
    ]);
  }
}
