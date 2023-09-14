import 'package:sepcon_salud/resource/model/control_medico_detalle_model.dart';

class ControlMedicoModel{
  late bool? hasDocument;
  late String? tipo;
  late bool? validated;
  late List<ControlMedicoDetalleModel>? controlMedico;

  ControlMedicoModel(this.hasDocument,this.tipo,
      this.validated,this.controlMedico);

  bool get _hasDocument => this.hasDocument!;
  String get _tipo => this.tipo!;
  bool get _validated => this.validated!;
  List<ControlMedicoDetalleModel> get _controlMedico => this.controlMedico!;

  ControlMedicoModel.fromJson(Map<String,dynamic> formatJson){
    hasDocument = formatJson['has_document']!;
    tipo = formatJson['tipo']!;
    validated = formatJson['validated']!;
    controlMedico = parseControlDetalle(formatJson['control_medico']);
  }


  List<ControlMedicoDetalleModel> parseControlDetalle(List<dynamic> parsed){
    return parsed.map<ControlMedicoDetalleModel>((json) =>
        ControlMedicoDetalleModel.fromJson(json)).toList();
  }
}

