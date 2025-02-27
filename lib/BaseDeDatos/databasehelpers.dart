import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {

  var status;
  var token;
  //String serverUrlproducts = "http://45.79.209.81:3000/products";
  String serverUrlproducts = "http://192.168.1.51:3000/products";

  //funciton getData
  Future<List> getData() async{

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "$serverUrlproducts";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
    });
    return json.decode(response.body);
   // print(response.body);
  }


  //function for register products
  void addDataProducto(String _nombreProducto, String _precioProducto, String _cantidadProducto, String _nitProveedor, String _categoria, String _descripcion, String _razonProveedor, String _mostrarStock) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

   // String myUrl = "$serverUrl/api";
   //String myUrl = "http://45.79.209.81:3000/products";
   String myUrl = "http://192.168.1.51:3000/products";
   final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "name":       "$_nombreProducto",
          "price":      "$_precioProducto",        
          "stock":      "$_cantidadProducto",
          "nit":        "$_nitProveedor",
          "categoria":  "$_categoria",
          "descripcion":"$_descripcion",
          "razon":      "$_razonProveedor",
          "mostrar":    "$_mostrarStock"
        } ) ;
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if(status){
      print('data : ${data["error"]}');
    }else{
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for update or put
  void editarProduct(String _id, String name, String price, String stock) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    //String myUrl = "http://45.79.209.81:3000/product/$_id";
    String myUrl = "http://192.168.1.51:3000/product/$_id";
    
    http.put(myUrl,
        body: {
         "name":       "$name",
         "price":       "$price",
         "stock":      "$stock"
        }).then((response){
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }


  //function for delete
  Future<void> removeRegister(String _id) async {

  //String myUrl = "http://45.79.209.81:3000/product/$_id";
  String myUrl = "http://192.168.1.51:3000/product/$_id";

  Response res = await http.delete("$myUrl");

  if (res.statusCode == 200) {
    print("DELETED");
  } else {
    throw "Can't delete post.";
  }
}

  //function save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

//function read
 read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    print('read : $value');
  }
}