import 'dart:convert';
import 'dart:developer';

import 'package:sepcon_salud/resource/model/vacuna_detail_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:http/http.dart' as http;

class VacunaApi{
  var client = http.Client();

  Future<VacunaModel?> vacunaByDocument(String documento) async {
    var url=Uri.parse('https://rrhhperu.sepcon.net/medica_api/documentosApi.php');
    var map = <String, dynamic>{};

    map['dni'] = documento;

    log('dni : $map');

    final response = await client.post(url,body:map);

    log("body ${response.body.toString()}" );
    if(response.statusCode==200){
      Map<String,dynamic > formatJson = jsonDecode(response.body);
      var documentoIdentidad = formatJson['documento_identidad']!;

      var detail = VacunaDetailModel.fromJson(documentoIdentidad);

      var emo = formatJson['EMO']!;
      var paseMedico = formatJson['pase_medico']!;
      var vacuna = formatJson['vacuna']!;

      var data = VacunaModel.fromJson(formatJson);
      log('result $data');
      return data;
    }else{
      log('fail');
      return null;
    }
  }
}