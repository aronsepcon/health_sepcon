import 'package:sepcon_salud/resource/model/tipo_vacuna_model.dart';

class VacunaDetailModel {
  late bool? hasDocument;
  late bool? validated;
  late bool? respuesta;
  late String? mensaje;
  late String? clase;
  late List<TipoVacunaModel?>? tipoVacunas;

  VacunaDetailModel(this.hasDocument,this.validated,this.respuesta,
      this.mensaje,this.clase);

  bool get _hasDocument => this.hasDocument!;
  bool get _validated => this.validated!;
  bool get _respuesta => this.respuesta!;
  String get _mensaje => this.mensaje!;
  String get _clase => this.clase!;
  List<TipoVacunaModel?> get _tipoVacunas => this.tipoVacunas!;

  VacunaDetailModel.fromJson(Map<String,dynamic> formatJson){
    hasDocument = formatJson['has_document']!;
    validated = formatJson['validated']!;
    respuesta = formatJson['respuesta']!;
    mensaje = formatJson['mensaje']!;
    clase = formatJson['clase']!;
    tipoVacunas = formatJson['tipo_vacunas']!;
  }
}

