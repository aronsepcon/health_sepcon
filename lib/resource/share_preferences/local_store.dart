import 'dart:convert';

import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_general_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStore{
  late SharedPreferences prefs;

  Future<SharedPreferences> init() async{
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  saveUser(LoginResponse loginResponse) async {
    SharedPreferences prefs = await init();
    await prefs.setString('NOMBRE', loginResponse.nombres!);
    await prefs.setString('CARGO_TRABAJADOR', loginResponse.cargoTrabajador!);
    await prefs.setString('DNI', loginResponse.dni!);
    await prefs.setString('CENTRO_COSTOS', loginResponse.centroCostos!);
    await prefs.setString('CENTRO_COSTOS_ID', loginResponse.centroCostosId!);
  }

  Future<LoginResponse?> fetchUser() async {

    SharedPreferences prefs = await init();
    if(prefs.getString('NOMBRE') == null){
      return null;
    }else{
      LoginResponse loginResponse = LoginResponse(true, "", "", true, "", "", "", "","","");

      loginResponse.nombres = prefs.getString('NOMBRE');
      loginResponse.cargoTrabajador = prefs.getString('CARGO_TRABAJADOR');
      loginResponse.dni = prefs.getString('DNI');
      loginResponse.centroCostos = prefs.getString('CENTRO_COSTOS');
      loginResponse.centroCostosId = prefs.getString('CENTRO_COSTOS_ID');
      return loginResponse;
    }
  }

  deleteUser() async {
    SharedPreferences prefs = await init();
    await prefs.remove('NOMBRE');
    await prefs.remove('CARGO_TRABAJADOR');
    await prefs.remove('DNI');
    await prefs.remove('CENTRO_COSTOS');
    await prefs.remove('CENTRO_COSTOS_ID');
  }

  saveDocuments(Map<String,dynamic> document) async {
    SharedPreferences prefs = await init();
    await prefs.setString('DOCUMENTOS', json.encode(document));
  }

  Future<DocumentVacunaModel?> fetchVacunaGeneral() async {
    SharedPreferences prefs = await init();
    var result = prefs.getString('DOCUMENTOS');
    if( result == null){
      return null;
    }else{
      Map<String,dynamic > formatJson = jsonDecode(result);
      DocumentVacunaModel documentVacunaModel =
      DocumentVacunaModel.formatJsonDocument(formatJson);
      return documentVacunaModel;
    }
  }

  saveVacunaCostos(Map<String,dynamic> vacunaCostos) async {
    SharedPreferences prefs = await init();
    await prefs.setString('VACUNA_COSTOS', json.encode(vacunaCostos));
  }

  Future<VacunaCostosModel?> fetchVacunaCostos() async {
    SharedPreferences prefs = await init();
    var result = prefs.getString('VACUNA_COSTOS');
    if( result == null){
      return null;
    }else{
      Map<String,dynamic > formatJson = jsonDecode(result);
      var vacunaCostosModel = VacunaCostosModel.fromJson(formatJson);
      return vacunaCostosModel;
    }
  }

  Future<bool> saveFilePaths(String typeDocument , List<String> filePaths) async{
    SharedPreferences prefs = await init();
    bool result = await prefs.setString(typeDocument, encode(filePaths));
    if(!result) return false;
    return true;
  }

  Future<List<String>> fetchPathsFileByTypeDocument(String typeDocument) async {
    SharedPreferences prefs = await init();
    var result = prefs.getString(typeDocument);
    if( result == null){
      return [];
    }else{
      List<String> pathFiles = decode(result);
      return pathFiles;
    }
  }

  Future<bool> deleteKey(String pattern) async{
    print(pattern);
    SharedPreferences prefs = await init();
    bool  result = await prefs.remove(pattern);
    return result;
  }

  static String encode(List<String> pathsPdf) => json.encode(
    pathsPdf.map<String>((pdf) => pdf.toString()).toList(),
  );

  static List<String> decode(String pathFiles) => json.decode(pathFiles)
          .map<String>((item) => item.toString())
          .toList();
}