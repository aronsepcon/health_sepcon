import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/documento_identidad_model.dart';
import 'package:sepcon_salud/resource/model/emo_model.dart';
import 'package:sepcon_salud/resource/model/pase_medico_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_general_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';

class VacunaApi{
  var client = http.Client();
  LocalStore localStore = LocalStore();

  Future<DocumentVacunaModel?> vacunaByDocument(String documento) async {

    var url=Uri.parse('https://rrhhperu.sepcon.net/medica_api/documentosApi.php');
    var map = <String, dynamic>{};
    map['dni'] = documento;
    final response = await client.post(url,body:map);

    if(response.statusCode==200){
      log('update data');
      log(response.body);
      Map<String,dynamic > formatJson = jsonDecode(response.body);
      localStore.saveDocuments(formatJson);
      var result = DocumentVacunaModel.formatJsonDocument(formatJson);

      return result;
    }else{
      log('fail');
      return null;
    }
  }


}