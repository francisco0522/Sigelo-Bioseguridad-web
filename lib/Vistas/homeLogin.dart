import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageLogin extends StatefulWidget {
  HomePageLogin({Key key, this.title, this.cliente}) : super(key: key);

  final String title;
  String cliente;

  @override
  _HomePageLogin createState() => _HomePageLogin();
}

class _HomePageLogin extends State<HomePageLogin> {
  
  SharedPreferences sharedPreferences;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null){}
  }

  Future<List> getData() async {
    //final response = await http.get("http://45.79.209.81:3000/products/");
final response = await http.get("http://192.168.1.51:3000/products/");
        
    return json.decode(response.body);
  }

    @override
  void initState() {
    super.initState();
    this.getData();
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
        iconTheme: new IconThemeData(color: Colors.grey[700]),
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
            widgetCarrito(),
            widgetUsuario(),
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
          color: Color.fromRGBO(180, 180, 180, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ), //       <--- BoxDecoration here
      child: new InkWell(
          onTap: () {},
          child: Row(children: <Widget>[
            Text(
              "Buscar productos de bioseguridad                                       ",
              style: TextStyle(
                  fontSize: 15.0, color: Color.fromRGBO(180, 180, 180, 1)),
            ),
            Icon(
              Icons.search,
              color: Color.fromRGBO(180, 180, 180, 1),
              size: 30.0,
            ),
          ])),
    );
  }

  Widget widgetCarrito() {
    return IconButton(
          icon: Icon(Icons.shopping_cart),
          tooltip: 'Ir al carrito de compras',
          onPressed: () {
            
          },
        );
  }

  Widget widgetUsuario() {
    return IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Ver mi Perfil',
          onPressed: () {
            
          },
        );
  }

  widgetBodyWeb() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
      //widgetCarousel(),
      //widgetInfo(),
      widgetTitulo(),
          widgetLabel(),
      widgetCardWeb(), 
    ]);
  }

   Widget widgetTitulo() {
    return Container(
        margin: const EdgeInsets.only(top: 50.0, bottom: 25.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Bienvenido " +  widget.cliente,
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 50),
          ),
        ));
  }

  widgetLabel() {
    return Container(
      padding: const EdgeInsets.only(left: 200.0),
      child: Row(children: <Widget>[
        Container(
          width: 40.0,
        ),
        Container(
          width: 200.0,
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Producto",
                  style: TextStyle(fontSize: 20.0),
                )
              ]),
        ),
        Container(
          width: 120.0,
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Precio",
                  style: TextStyle(fontSize: 20.0),
                )
              ]),
        ),
        Container(
          width: 150.0,
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Categoria",
                  style: TextStyle(fontSize: 20.0),
                )
              ]),
        ),
        Container(
          width: 150.0,
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "En Stock",
                  style: TextStyle(fontSize: 20.0),
                )
              ]),
        ),
        Container(
          width: 150.0,
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Proveedor",
                  style: TextStyle(fontSize: 20.0),
                )
              ]),
        ),
      ]),
    );
  }

  widgetCardWeb(){
    return Expanded(
              flex: 8,
              child: FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new ItemListWeb(
                          list: snapshot.data,
                        )
                      : new Center(
                          child: new CircularProgressIndicator(),
                        );
                },
              ));
  }

  widgetCarousel() {
    return Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        decoration: new BoxDecoration(color: Color.fromRGBO(253, 89, 98, 1)),
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
                    child: Center(child: Image.network(item, fit: BoxFit.fill)),
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
        iconTheme: new IconThemeData(color: Colors.grey[700]),
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
          color: Color.fromRGBO(180, 180, 180, 1),
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
            color: Color.fromRGBO(200, 200, 200, 1),
          ),
        ),
        ListTile(
          title: Text('Comprar'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Perfil'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  widgetBodyMobile() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
      //widgetCarouselMobile(),
      //widgetInfoMobile(),
      widgetCardMobile(),
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
    return Expanded(
        child: Column(children: <Widget>[
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
    ]));
  }

  widgetCardMobile(){
return Expanded(
              flex: 8,
              child: FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new ItemList(
                          list: snapshot.data,
                        )
                      : new Center(
                          child: new CircularProgressIndicator(),
                        );
                },
              ));
  }



}


class ItemListWeb extends StatelessWidget {
  final List list;
  String razon;
  ItemListWeb({this.list, this.razon});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: const EdgeInsets.only(right: 80.0, left: 200.0, bottom: 10.0),
          child: Card(
            elevation: 8,
            child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Row(
                children: <Widget>[
              Image.asset(
                'assets/images/add.png',
                width: 80.0,
                height: 80.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                width: 180.0,
                child: Text( list[i]['name'].toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0))),
                  
                Container(
                padding: const EdgeInsets.only(left: 20.0),
                width: 120.0,
                child: Text(               
                                list[i]['price'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                          )),
                Container(
                padding: const EdgeInsets.only(left: 20.0),
                width: 150.0,
                child: Text(
                            list[i]['categoria'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                          )),
                Container(
                padding: const EdgeInsets.only(left: 20.0),
                width: 150.0,
                child:Text(
                            list[i]['stock'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                )),
                Container(
                padding: const EdgeInsets.only(left: 20.0),
                width: 180.0,
                child:Text(
                            list[i]['razon'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                ))
                
                ]),
                      
          ])),
        );
      },
    );
  }
}


class ItemList extends StatelessWidget {
  final List list;
  String razon;
  ItemList({this.list, this.razon});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: const EdgeInsets.only(right: 80.0, left: 80.0, bottom: 30.0),
          child: Card(
            elevation: 8,
            child: Column(children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Column(children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(
                        right: 50.0, top: 20.0, bottom: 20.0),
                    child: RichText(
                      text: TextSpan(
                        text: list[i]['name'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\nPrecio: ' +
                                list[i]['price'].toString() +
                                "\$",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                          ),
                          TextSpan(
                            text: '\n' + list[i]['categoria'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                          ),
                          TextSpan(
                            text: '\nEn Stock:' + list[i]['stock'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                    )),
              ]),
              Image.asset(
                'assets/images/add.png',
                width: 80.0,
                height: 80.0,
              ),
            ]),
            Container(
                padding: const EdgeInsets.only(left: 20.0),
                width: 180.0,
                child:Text(
                            "Proveedor: " + list[i]['razon'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                ))
          ])),
        );
      },
    );
  }
}
