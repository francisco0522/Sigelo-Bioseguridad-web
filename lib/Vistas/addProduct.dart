import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../BaseDeDatos/databasehelpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeProveedor.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


final _nombreProducto = TextEditingController();
final _precioProducto = TextEditingController();
final _descripcionProducto = TextEditingController();
final _cantidadProducto = TextEditingController();
String dropdownValue1 = 'No mostrar el stock';
String dropdownValue = 'Seleccione una categoria*';
bool value;
bool value1;
Function onChanged;
Uint8List uploadedImage;

class PageAddProduct extends StatefulWidget {
  String nitProveedor;
  String razonProveedor;
  PageAddProduct({Key key, this.nitProveedor, this.razonProveedor})
      : super(key: key);

  @override
  _PageAddProduct createState() => _PageAddProduct();
}

class _PageAddProduct extends State<PageAddProduct> {
  Image pickedImage;
  Image pickedImage1;
  Image pickedImage2;
  String buttonLabel = "Agregar Imagen";
  String buttonLabel1 = "Agregar Imagen";
  String buttonLabel2 = "Agregar Imagen";


  upload() async {
    final bytes = await File(pickedImage.semanticLabel).readAsBytes();
    Map data = {
    'image': bytes,
    'title': "prueba 1",
    'description': "prueba 1",
    'name': "prueba 1",
    'type': "base64"
  };
  var jsonResponse = null;
  var response = await http.post("https://api.imgur.com/3/upload", headers: {
  
      'Authorization': 'Bearer b18d9d4ec65cb639a68ac23aa8bc524b4d9145d0',
    }, body: data);

   jsonResponse = json.decode(response.body);
   print(jsonResponse);
  
}

  //web//
  /*pickImage() async {
    Image fromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
        buttonLabel = "Cambiar Imagen";
      });
    }
  }

  pickImage1() async {
    Image fromPicker1 =
        await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker1 != null) {
      setState(() {
        pickedImage1 = fromPicker1;
        buttonLabel1 = "Cambiar Imagen";
      });
    }
  }

  pickImage2() async {
    Image fromPicker2 =
        await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker2 != null) {
      setState(() {
        pickedImage2 = fromPicker2;
        buttonLabel2 = "Cambiar Imagen";
      });
    }
  }*/

  Future<File> imageFile;
  DataBaseHelper databaseHelper = new DataBaseHelper();

  getImage(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        child: SizedBox(
          width: 150,
          child: pickedImage,
        ));
  }

  Widget showImage1() {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        child: SizedBox(
          width: 150,
          child: pickedImage1,
        ));
  }

  Widget showImage2() {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        child: SizedBox(
          width: 150,
          child: pickedImage2,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return web();
        }
        return web();
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
          Row(children: <Widget>[widgetVolver()])
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePageProveedor(
                      nitProveedor: widget.nitProveedor,
                      razonProveedor: widget.razonProveedor)),
              (Route<dynamic> route) => false);
        },
        child: Text(
          "Volver",
          style: TextStyle(fontSize: 15.0, color: Color.fromRGBO(0, 0, 0, 1)),
        ),
      ),
    );
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

  Widget widgetTitulo() {
    return Container(
        margin: const EdgeInsets.only(top: 50.0, bottom: 50.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Agregar producto",
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 50),
          ),
        ));
  }

  widgetBodyWeb() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: ListView(children: <Widget>[
          widgetTitulo(),
          widgetAddImages(),
          widgetInputsFields()
        ]));
  }

  widgetAddImages() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Column(children: <Widget>[
        showImage(),
        RaisedButton(
          onPressed: () {
         //   pickImage();
          },
          color: Colors.blue,
          child: new Text(
           buttonLabel,
            style: new TextStyle(
                color: Colors.white, backgroundColor: Colors.blue),
          ),
        ),
      ]),
      Column(children: <Widget>[
        showImage1(),
        RaisedButton(
          onPressed: () {
           // pickImage1();
          },
          color: Colors.blue,
          child: new Text(
            buttonLabel1,
            style: new TextStyle(
                color: Colors.white, backgroundColor: Colors.blue),
          ),
        ),
      ]),
      Column(children: <Widget>[
        showImage2(),
        RaisedButton(
          onPressed: () {
            //pickImage2();
          },
          color: Colors.blue,
          child: new Text(
            buttonLabel2,
            style: new TextStyle(
                color: Colors.white, backgroundColor: Colors.blue),
          ),
        ),
      ]),
    ]);
  }

  widgetInputsFields() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: "*Campo obligatorio",
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20),
          ),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 10.0, top: 5.0),
          child: TextFormField(
            controller: _nombreProducto,
            decoration: const InputDecoration(
              hintText: 'Nombre del producto*',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _precioProducto,
            decoration: const InputDecoration(
              hintText: 'Precio del producto*',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _cantidadProducto,
            decoration: const InputDecoration(
              hintText: 'Cantidad en Stock*',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 10.0, top: 20.0),
          child: TextFormField(
            maxLines: 8,
            controller: _descripcionProducto,
            decoration: const InputDecoration(
              hintText: 'Descripción del producto',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Row(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Categoria del producto",
                style:
                    TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Color.fromRGBO(188, 35, 35, 1),
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  'Seleccione una categoria*',
                  'Protección de la cara',
                  'Ropa de protección',
                  'Equipos',
                  'Alcohol',
                  'Alcohol glicerinado',
                  'Gel antibacterial',
                  'Jabón desinfectante',
                  'Desinfectantes',
                  'Insumos'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
        ]),
      ]),
      Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: DropdownButton<String>(
                value: dropdownValue1,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Color.fromRGBO(188, 35, 35, 1),
                ),
                onChanged: (String newValue1) {
                  setState(() {
                    dropdownValue1 = newValue1;
                  });
                },
                items: <String>[
                  'No mostrar el stock',
                  'Mostrar el stock'
                ].map<DropdownMenuItem<String>>((String value1) {
                  return DropdownMenuItem<String>(
                    value: value1,
                    child: Text(value1),
                  );
                }).toList(),
              )),
      RaisedButton(
        onPressed: () {
          if(_nombreProducto.text == "" || _precioProducto.text == "" || _cantidadProducto.text == "" || dropdownValue == 'Seleccione una categoria*'){
            _campoVacio();
          }
          else{
          databaseHelper.addDataProducto(
              _nombreProducto.text.trim(),
              _precioProducto.text.trim(),
              _cantidadProducto.text.trim(),
              widget.nitProveedor,
              dropdownValue,
              _descripcionProducto.text.trim(),
              widget.razonProveedor,
              dropdownValue1);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePageProveedor(
                      nitProveedor: widget.nitProveedor,
                      razonProveedor: widget.razonProveedor)),
              (Route<dynamic> route) => false);
          _nombreProducto.clear();
          _precioProducto.clear();
          _cantidadProducto.clear();
          dropdownValue = 'Seleccione una categoria*';
          dropdownValue1 = 'No mostrar el stock';
          _descripcionProducto.clear();
        }},
        color: Colors.blue,
        child: new Text(
          'Agregar',
          style:
              new TextStyle(color: Colors.white, backgroundColor: Colors.blue),
        ),
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
              Text('Por favor llene todos los campos requeridos'),
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
        iconTheme: new IconThemeData(color: Colors.grey[700]),
      ),
      body: widgetBodyWeb(),
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
    return ListView(children: <Widget>[]);
  }
}
