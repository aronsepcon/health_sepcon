import 'package:sepcon_salud/resource/model/vacuna_detalle_model.dart';

class VacunaModel{
  late int? id;
  late String? nombre;
  late String? nomenclatura;
  late String? estado;
  late String? adjunto;
  late bool? validated;
  late bool? hasDocument;
  late VacunaDetalleModel? vacunaDetalle;

  VacunaModel(this.id,this.nombre,this.estado,this.adjunto,this.validated,
      this.hasDocument,this.nomenclatura,
      this.vacunaDetalle);

  VacunaModel.fromJson(Map<String,dynamic> formatJson){
    id = formatJson['id'];
    nombre = formatJson['nombre'];
    estado = formatJson['estado'];
    adjunto = formatJson['adjunto'] == null ? "" : formatJson['adjunto'];
    validated = formatJson['validated'];
    nomenclatura = formatJson['nomenclatura'];
    hasDocument = formatJson['has_document'];
    vacunaDetalle = VacunaDetalleModel.fromJson(formatJson['vacunas_detalle']);
  }
}

