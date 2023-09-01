import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sepcon_salud/resource/model/centro_costos_model.dart';
import 'package:sepcon_salud/resource/model/centro_costos_response_model.dart';

class CentroCostosApi{

  var client = http.Client();

  Future<List<CentroCostosModel>> listCentroCostos() async{
    var url = Uri.parse('https://rrhhperu.sepcon.net/medica_api/ccostosApi.php');
    var response = await http.get(url);
    if(response.statusCode == 200) {
      log("respuesta "+ response.body);
      return parseCentroCostos(response.body);
    }else{
      return [];
    }
  }

  List<CentroCostosModel> parseCentroCostos(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<CentroCostosModel>((json)=> CentroCostosModel.fromJson(json)).toList();
  }

  Future<CentroCostosResponse?> registerCentroCostos(String document,String id) async {
    var url=Uri.parse('https://rrhhperu.sepcon.net/medica_api/registrarCcostos.php');
    var map = <String, dynamic>{};

    map['dni'] = document;
    map['ccostos'] = id;

    log('map $map');

    final response = await client.post(url,body:map);

    if(response.statusCode==200){
      Map<String,dynamic> json = jsonDecode(response.body);
      var data = CentroCostosResponse.fromJson(json);
      log('result $data');
      return data;
    }else{
      log('fail');
      return null;
    }
  }

}