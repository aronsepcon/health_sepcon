import 'package:sepcon_salud/resource/model/vacuna_detalle_model.dart';
enum VigenciaVacuna{
  empty,// sin fecha
  active, //con fecha
  toExpire, // con dos fecha y la segunda tiene siete dias para vencerse
  noActive // paso la fecha vencida
}

class VacunaModel{
  late int? id;
  late String? nombre;
  late String? nomenclatura;
  late String? estado;
  late String? adjunto;
  late bool? validated;
  late bool? hasDocument;
  late bool? requiredVacuum;
  late VigenciaVacuna vigenciaVacuna;
  late VacunaDetalleModel? vacunaDetalle;
  late int? amountDay;

  VacunaModel(this.id,this.nombre,this.estado,this.adjunto,this.validated,
      this.hasDocument,this.nomenclatura,
      this.vacunaDetalle,this.vigenciaVacuna,this.amountDay,this.requiredVacuum);

  VacunaModel.fromJson(Map<String,dynamic> formatJson){
    print("esto es: $formatJson");
    id = formatJson['id'] ?? 0;
    nombre = formatJson['nombre']?? "";
    estado = formatJson['estado']?? "";
    adjunto = formatJson['adjunto'] ?? "";
    validated = formatJson['validated'] ?? false;
    nomenclatura = formatJson['nomenclatura'] ?? "";
    hasDocument = formatJson['has_document'] ?? false;
    vigenciaVacuna = VigenciaVacuna.empty;
    amountDay = 0;
    requiredVacuum = formatJson['obligatoria'] ?? false;
    vacunaDetalle = VacunaDetalleModel.fromJson(formatJson['vacunas_detalle']);
  }
}

