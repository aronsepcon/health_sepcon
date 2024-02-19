import 'dart:convert';

import 'package:sepcon_salud/resource/model/vacuna_model.dart';

class VacunaGeneralModel{
  late bool? hasDocument;
  late bool? validated;
  late String? documentGeneral;
  late List<VacunaModel>? tiposVacunas;

  VacunaGeneralModel(this.hasDocument,this.validated,this.documentGeneral,
      this.tiposVacunas);

  VacunaGeneralModel.fromJson(Map<String,dynamic> formatJson){
    hasDocument = formatJson['has_document_general'] ?? false;
    validated = formatJson['validated'] ?? false;
    documentGeneral = formatJson['document_general'] ?? "";
    tiposVacunas = parseVacunaModel(formatJson['tipos_vacunas']) ?? [];
  }

  List<VacunaModel> parseVacunaModel(List<dynamic> parsed){
    //final parsed = json.decode(responseBody).cast<Map<String, dynamic>>(); 
    return parsed.map<VacunaModel>((json)=>VacunaModel.fromJson(json)).toList();
  }
}