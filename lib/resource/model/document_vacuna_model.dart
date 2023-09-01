import 'package:sepcon_salud/resource/model/documento_identidad_model.dart';
import 'package:sepcon_salud/resource/model/emo_model.dart';
import 'package:sepcon_salud/resource/model/pase_medico_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_general_model.dart';

class DocumentVacunaModel{

  late DocumentoIdentidadModel documentoIdentidadModel;
  late EmoModel? emoModel;
  late PaseMedicoModel? paseMedicoModel;
  late VacunaGeneralModel?  vacunaGeneralModel;

  DocumentVacunaModel(this.documentoIdentidadModel,this.emoModel,this.paseMedicoModel,
      this.vacunaGeneralModel);

  static DocumentVacunaModel formatJsonDocument(Map<String,dynamic > formatJson){
    var documentoIdentidad = formatJson['documento_identidad']!;
    var dataDocumentoIdentidad = DocumentoIdentidadModel.fromJson(documentoIdentidad);

    var emo = formatJson['EMO']!;
    var dataEmo = EmoModel.fromJson(emo);

    var paseMedico = formatJson['pase_medico']!;
    var dataPaseMedico = PaseMedicoModel.fromJson(paseMedico);

    var vacuna = formatJson['vacuna']!;
    var dataVacuna = VacunaGeneralModel.fromJson(vacuna);

    DocumentVacunaModel documentVacunaModel = DocumentVacunaModel(
        dataDocumentoIdentidad, dataEmo,dataPaseMedico,
        dataVacuna);

    return documentVacunaModel;
  }
}