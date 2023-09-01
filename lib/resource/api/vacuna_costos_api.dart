import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';

class VacunaCostosApi{

  var localStore = LocalStore();
  var client = http.Client();

  Future<VacunaCostosModel?> fetchVacunaByCentroCostos(String? centroCostosId) async {
    var url=Uri.parse('https://rrhhperu.sepcon.net/medica_api/vacunaCcostos.php');
    var map = <String, dynamic>{};

    map['ccostos'] = centroCostosId;

    log(' centro costos : $centroCostosId');

    final response = await client.post(url,body:map);

    if(response.statusCode==200){
      Map<String,dynamic> json = jsonDecode(response.body);
      localStore.saveVacunaCostos(json);
      var data = VacunaCostosModel.fromJson(json);
      log("data : ${json}");
      return data;
    }else{
      return null;
    }
  }
}