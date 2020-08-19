import 'dart:convert';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homeLogin.dart';
import 'homeProveedor.dart';

final _usernameController = TextEditingController();
final _passwordController = TextEditingController();


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;

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
        iconTheme: new IconThemeData(color: Color.fromRGBO(179, 179, 179, 1)),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only( right: 20.0, left: 20.0),
          color: Color.fromRGBO(179, 179, 179, 1),
              child: Column(children: <Widget>[
                widgetTitulo(),
                widgetNombreUsuario(),
                wigdetContrasena(),
                wigdetBtnLogin(),
                ],
              ),
          )
      ),
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
            widgetVolver(),
          ])
        ]));
  }



  Widget widgetVolver() {
    return Container(
      padding: const EdgeInsets.only(
          left: 30.0, top: 10.0, bottom: 10.0, right: 30.0),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color.fromRGBO(240, 240, 240, 1),
      ), //       <--- BoxDecoration here
      child: new InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Text(
          "Volver",
          style: TextStyle(fontSize: 15.0, color: Color.fromRGBO(0, 0, 0, 1)),
        ),
      ),
    );
  }

  Widget widgetTitulo(){
    return  Container(
            margin: const EdgeInsets.only(top: 100.0, bottom: 50.0),
              child:RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Iniciar Sesión",
                  style: TextStyle(                     
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 50),
                ),
              )
  );
  }

  Widget widgetNombreUsuario() {
  return Container(      
      padding: const EdgeInsets.only( bottom: 50.0),
      child: TextFormField(        
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
    );
}

Widget wigdetContrasena() {
  return Container(  
      padding: const EdgeInsets.only(bottom: 50.0),
      child: TextFormField(        
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Contraseña',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
  );
}

Widget wigdetBtnLogin() {
  return Container(
      child: 
          RaisedButton(
            onPressed: (){
              setState(() {
                _isLoading = true;
              });
              if(_usernameController.text == "" || _passwordController.text == "")
              { _campoVacio();
              }
              else{
              signIn(_usernameController.text, _passwordController.text);
              }
            },
            child: Text('Ingresar'),
          )
    );
}

Future<void> _campoVacio() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hay un campo vacio'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Por favor llene todos los campos'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
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
        iconTheme: new IconThemeData(color: Color.fromRGBO(179, 179, 179, 1)),
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(179, 179, 179, 1),
              child: ListView(children: <Widget>[
                widgetTituloMobile(),
                widgetNombreUsuarioMobile(),
                wigdetContrasenaMobile(),
                wigdetBtnLoginMobile(),
                ],
              ),
          )
      ),
    );
  }

   appBarMobile() {
    return Container(
        child: Row(children: <Widget>[
      widgetLogo(),
    ]));
  }

  Widget widgetTituloMobile(){
    return  Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child:RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Iniciar Sesión",
                  style: TextStyle(                     
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 50),
                ),
              )
  );
  }

Widget widgetNombreUsuarioMobile() {
  return Container(      
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
      child: TextFormField(        
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
    );
}

Widget wigdetContrasenaMobile() {
  return Container(  
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
      child: TextFormField(        
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Contraseña',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
  );
}

Widget wigdetBtnLoginMobile() {
  return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: 
          RaisedButton(
            onPressed: (){
              setState(() {
                _isLoading = true;
              });
              signIn(_usernameController.text, _passwordController.text);
            },
            child: Text('Ingresar'),
          )
    );
}







// FUNCIONES //

signIn(String usuario, pass)async{
  /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Map data = {
    'email': usuario,
    'password': pass
  };
  var jsonResponse = null;
  //var response = await http.post("http://45.79.209.81:3000/signin", body: data);
  var response = await http.post("http://192.168.1.51:3000/signin", body: data);
  
  jsonResponse = json.decode(response.body);
  print(response.statusCode);
  */

  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$usuario:$pass'));
  print(basicAuth);


  var response = await http.get('http://50.116.46.197/api/1.0/me/perfil/',
      headers: {'content-type': 'application/json',
    'accept': 'application/json',
    'authorization': basicAuth});
  print(response.statusCode);
 
  var jsonResponse = json.decode(response.body);
  print(jsonResponse['nombres']);
  if(response.statusCode == 200){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageLogin()), (Route<dynamic> route) => false);
    }
  

/*
  if(response.statusCode == 200){
    var cliente = jsonResponse['cliente'];
   var nit = jsonResponse['nit'];
  var razon = jsonResponse['razon'];
    setState(() {
      _isLoading = false;
    });
    sharedPreferences.setString("token", jsonResponse['token']);
    if (jsonResponse['rol'] == "cliente"){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageLogin(cliente: cliente )), (Route<dynamic> route) => false);
    }
    else if (jsonResponse['rol'] == "proveedor"){
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageProveedor(nitProveedor: nit, razonProveedor: razon)), (Route<dynamic> route) => false);
    }
  }
  else {
     _malIngreso();
    setState(() {
      _isLoading = false;
    });
   
  }*/
}



Future<void> _malIngreso() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hay uno o mas datos incorrectos'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Por favor verifique la información y vuelva a intentarlo'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}

