import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'addProduct.dart';

class HomePageProveedor extends StatefulWidget {
  String nitProveedor;
  String razonProveedor;

  HomePageProveedor({Key key, this.nitProveedor, this.razonProveedor})
      : super(key: key);
  @override
  _HomePageProveedor createState() => _HomePageProveedor();
}

class _HomePageProveedor extends State<HomePageProveedor> {
  List data;

  Future<List> getData() async {
    //final response = await http.get("http://45.79.209.81:3000/productBy/" + widget.nitProveedor);
    final response = await http.get("http://192.168.1.51:3000/productBy/" + widget.nitProveedor);
    
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
          ]),
          Row(children: <Widget>[
            widgetUsuario(),
          ])
        ]));
  }

  Widget widgetUsuario() {
    return IconButton(
      icon: Icon(Icons.person),
      tooltip: 'Ver mi Perfil',
      onPressed: () {},
    );
  }

  Widget widgetTitulo() {
    return Container(
        margin: const EdgeInsets.only(top: 50.0, bottom: 25.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.razonProveedor,
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 50),
          ),
        ));
  }

  widgetBodyWeb() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          widgetTitulo(),
          widgetAdd(),
          widgetLabel(),
          widgetCardWeb(),          
        ]);
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
                          razon: widget.razonProveedor,
                        )
                      : new Center(
                          child: new CircularProgressIndicator(),
                        );
                },
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
      ]),
    );
  }

  widgetAdd() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => PageAddProduct(
                    nitProveedor: widget.nitProveedor,
                    razonProveedor: widget.razonProveedor)),
            (Route<dynamic> route) => false);
      },
      child: Text('Agregar un producto nuevo'),
    );
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
    ]));
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
          title: Text('Registrarse'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Iniciar Sesión'),
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
          widgetTitulo(),
          widgetAdd(),
          widgetCardMobile(),
          
        ]);
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
                          razon: widget.razonProveedor,
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
                width: 70.0,
                child:Text(
                            list[i]['stock'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),
                ))]),
                      
                  

              
           ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Editar'),
                  onPressed: () {
                    print(razon);},
                ),
                FlatButton(
                  child: const Text('Eliminar'),
                  onPressed: () {
                    preguntarSiEliminar(context, list[i]['_id'].toString(), list[i]['name'].toString(), list[i]['nit'].toString(), razon);
                  },
                ),
              ],
            ),
          ])),
        );
      },
    );
  }
}


Future<void> preguntarSiEliminar(BuildContext context, id, product, nit, razon) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Eliminar ' + product),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('¿Esta seguro de eliminar ' + product + '?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Si'),
            onPressed: () {
              deleteProduct(id, context, nit, razon);
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

deleteProduct(String id, BuildContext context, nit, razon)async{


//await http.delete("http://45.79.209.81:3000/product/" + id);
await http.delete("http://192.168.1.51:3000/product/" + id);



                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageProveedor(nitProveedor: nit, razonProveedor: razon)), (Route<dynamic> route) => false);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey),
                      right: BorderSide(width: 1.0, color: Colors.grey),
                    )),
                    child: FlatButton(
                      child: const Text('Editar', style: TextStyle()),
                      onPressed: () {
                        print(razon);
                      },
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey),
                    )),
                    child: FlatButton(
                      child: const Text('Eliminar', style: TextStyle()),
                      onPressed: () {
                     preguntarSiEliminar(context, list[i]['_id'].toString(), list[i]['name'].toString(), list[i]['nit'].toString(), razon);


                      },
                    )),
              ],
            ),
          ])),
        );
      },
    );
  }
}
