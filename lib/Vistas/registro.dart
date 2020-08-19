import 'dart:convert';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homeLogin.dart';
import 'homeProveedor.dart';

final _clientNameController = TextEditingController();
final _clientMailController = TextEditingController();
final _clientPassController = TextEditingController();
final _clientAddressController = TextEditingController();
final _clientPhoneController = TextEditingController();
final _provPassController = TextEditingController();
final _provMailController = TextEditingController();
final _provPhoneController = TextEditingController();
final _provRazonController = TextEditingController();
final _provNitController = TextEditingController();


class RegistroPage extends StatefulWidget {
  RegistroPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegistroPage createState() => _RegistroPage();
}

class _RegistroPage extends State<RegistroPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  bool _isLoading = false;

  final ScrollController _scrollController = ScrollController();
  

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
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        color: Color.fromRGBO(179, 179, 179, 1),
        child: Column(
          children: <Widget>[
            widgetTitulo(),
            widgetTabs(),
            widgetInfoTabs(),
          ],
        ),
      )),
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

  Widget widgetTitulo() {
    return Container(
        margin: const EdgeInsets.only(top: 100.0, bottom: 50.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Regístrate",
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 50),
          ),
        ));
  }

  Widget widgetTabs() {
    return Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(188, 35, 35, 1),
         borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
      child: new TabBar(
        controller: _controller,
        labelColor: Color.fromRGBO(188, 35, 35, 1),
        unselectedLabelColor: Colors.white,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                 border: Border.all(color: Color.fromRGBO(240, 240, 240, 1), width: 1),
            color: Colors.white),
        tabs: [
          Tab(            
            child: Align(
              alignment: Alignment.center,
              child: Text("Cliente"),
          )
          ),
          Tab(
            
            child: Align(
              alignment: Alignment.center,
              child: Text("Proveedor"),
          )
          ),
        ],
      ),
    );
  }

  Widget widgetInfoTabs() {
    return Container(
      height: 500.0,
      padding: const EdgeInsets.only(top: 50.0),
      color: Color.fromRGBO(255, 255, 255, 0.8),
      child: new TabBarView(
        controller: _controller,
        children: <Widget>[
          widgetCliente(),
          widgetProveedor(),
        ],
      ),
    );
  }

  Widget widgetCliente() {
    return Scrollbar(
       isAlwaysShown: true,
       controller: _scrollController,
    child: ListView(
       children: <Widget>[
      Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _clientNameController,
        decoration: const InputDecoration(
          hintText: 'Nombre y apellidos',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _clientMailController,
        decoration: const InputDecoration(
          hintText: 'E-mail',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _clientPassController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Contraseña',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _clientAddressController,
        decoration: const InputDecoration(
          hintText: 'Dirección de entrega',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _clientPhoneController,
        decoration: const InputDecoration(
          hintText: 'Teléfono',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

     Container(
    padding: const EdgeInsets.only(top: 50.0),
      child: 
          RaisedButton(
            onPressed: (){
              setState(() {
                _isLoading = true;
              });
              if(_clientNameController.text == "" ||  _clientMailController.text == "" || _clientPassController.text == "" || _clientAddressController.text == "" || _clientPhoneController.text == ""){
                  _campoVacio();
              }else{
              signUpCliente(_clientNameController.text, _clientMailController.text, _clientPassController.text, _clientAddressController.text, _clientPhoneController.text);
            }},
            child: Text('Registrarse'),
          )
    ),


       ]));
  }

  Widget widgetProveedor() {
    return ListView(
       children: <Widget>[
      Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _provNitController,
        decoration: const InputDecoration(
          hintText: 'NIT',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),


    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _provRazonController,
        decoration: const InputDecoration(
          hintText: 'Razón social',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _provPhoneController,
        decoration: const InputDecoration(
          hintText: 'Teléfono',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _provMailController,
        decoration: const InputDecoration(
          hintText: 'E-mail',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        controller: _provPassController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Contraseña',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ),

    Container(
    padding: const EdgeInsets.only(top: 50.0),
      child: 
          RaisedButton(
            onPressed: (){
              setState(() {
                _isLoading = true;
              });
              if(_provNitController.text == "" || _provRazonController.text == "" || _provPhoneController.text == "" || _provMailController.text == "" || _provPassController.text == ""){
                  _campoVacio();
              }else{
              signUpProveedor(_provNitController.text, _provRazonController.text, _provPhoneController.text, _provMailController.text, _provPassController.text);
            }},
            child: Text('Registrarse'),
          )
    ),

       ]);
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
        child: ListView(
          children: <Widget>[
            widgetTituloMobile(),
            widgetTabs(),
            widgetInfoTabs(),
          ],
        ),
      )),
    );
  }

  appBarMobile() {
    return Container(
        child: Row(children: <Widget>[
      widgetLogo(),
    ]));
  }

   Widget widgetTituloMobile() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, bottom: 15.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Regístrate",
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 50),
          ),
        ));
  }




// FUNCIONES //


  signUpCliente(String nombre, mail, pass, address, phone) async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map dataOldUser = {
    'email': mail
  };
        //var responseOldUser = await http.post("http://45.79.209.81:3000/searchUser", body: dataOldUser);
        var responseOldUser = await http.post("http://192.168.1.51:3000/searchUser", body: dataOldUser);
        
        var jsonResponseOld = json.decode(responseOldUser.body);
        print(jsonResponseOld['existe']);
  if(jsonResponseOld['existe'] == true){
    _emailExiste();
  }
  else{
    Map data = {'username': nombre, 'email': mail, 'password': pass, 'address':address, 'phone':phone};
    //var response = await http.post("http://45.79.209.81:3000/signupClient", body: data);
    var response = await http.post("http://192.168.1.51:3000/signupClient", body: data);
        
    var jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        _isLoading = false;
      });
      sharedPreferences.setString("token", jsonResponse['token']);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageLogin(cliente: nombre )), (Route<dynamic> route) => false);

    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }
  }

Future<void> _emailExiste() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('El correo ya existe'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Por favor utilice otro correo o ingrese sesión'),
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



  signUpProveedor(String nit, razon, phone, mail, pass) async {
    Map dataOldUser = {
    'email': mail
  };
       // var responseOldUser = await http.post("http://45.79.209.81:3000/searchUser", body: dataOldUser);
        var responseOldUser = await http.post("http://192.168.1.51:3000/searchUser", body: dataOldUser);
        
        var jsonResponseOld = json.decode(responseOldUser.body);
  if(jsonResponseOld['existe'] == true){
    _emailExiste();
  }
  else{
    Map data = {'nit': nit, 'razon': razon, 'phone': phone, 'email':mail, 'password':pass};
    var jsonResponse = null;
    //var response = await http.post("http://45.79.209.81:3000/signupProveedor", body: data);
    var response = await http.post("http://192.168.1.51:3000/signupProveedor", body: data);
        
    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      setState(() {
        _isLoading = false;
      });
   
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePageProveedor(nitProveedor: nit, razonProveedor: razon)), (Route<dynamic> route) => false);

    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }
  }


}
