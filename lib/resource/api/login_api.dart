import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sepcon_salud/resource/model/login_response.dart';

class LoginApi{

  var client = http.Client();

  Future<LoginResponse?> fetchLogin(String document,String password) async{

    var url=Uri.parse('https://rrhhperu.sepcon.net/medica_api/apiPostulantes.php');
    var map = <String, dynamic>{};

    map['dni'] = document;
    map['password'] = password;

    log('data: $document');
    log('data: $password');

    final response = await client.post(url,body:map);

    if(response.statusCode==200){
      Map<String,dynamic> json = jsonDecode(response.body);
      var data = LoginResponse.fromJson(json);
      return data;
    }else{
      return null;
    }
  }

}