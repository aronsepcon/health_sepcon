import 'package:sepcon_salud/resource/model/vacuna_detail_model.dart';

class VacunaModel{
  late VacunaDetailModel documentoIdentidad;
  late VacunaDetailModel emo;
  late VacunaDetailModel paseMedico;
  late VacunaDetailModel vacuna;

  VacunaModel(this.documentoIdentidad,this.emo,this.paseMedico,this.vacuna);

  VacunaDetailModel get _documentoIdentidad => this.documentoIdentidad;
  VacunaDetailModel get _emo => this.emo;
  VacunaDetailModel get _paseMedico => this.paseMedico;
  VacunaDetailModel get _vacuna => this.vacuna;

  VacunaModel.fromJson(Map<String,dynamic> formatJson){
    documentoIdentidad = formatJson['documento_identidad']!;
    emo = formatJson['EMO']!;
    paseMedico = formatJson['pase_medico']!;
    vacuna = formatJson['vacuna']!;
  }
}

