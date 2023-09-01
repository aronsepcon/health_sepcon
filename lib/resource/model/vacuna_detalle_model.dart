import 'package:sepcon_salud/resource/model/dosis_model.dart';
import 'package:sepcon_salud/resource/model/refuerzo_model.dart';

class VacunaDetalleModel{
  late List<DosisModel> dosis;
  late List<RefuerzoModel> refuerzos;

  VacunaDetalleModel(this.dosis,this.refuerzos);

  VacunaDetalleModel.fromJson(Map<String,dynamic> formatJson){
    dosis = parseDosisModel(formatJson['dosis']);
    refuerzos = parseRefuerzoModel(formatJson['refuerzos']);
  }

  List<DosisModel> parseDosisModel(List<dynamic> parsed){
    return parsed.map<DosisModel>((json)=> DosisModel.fromJson(json)).toList();
  }

  List<RefuerzoModel> parseRefuerzoModel(List<dynamic> parsed){
    return parsed.map<RefuerzoModel>((json)=> RefuerzoModel.fromJson(json)).toList();
  }
}