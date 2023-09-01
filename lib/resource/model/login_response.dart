
class LoginResponse{
  late bool? respuesta;
  late String? clase;
  late String? error;
  late bool? isAquarius;
  late String? codigoUnicoTrabajador;
  late String? nombres;
  late String? cargoTrabajador;
  late String? dni;
  late String? centroCostosId;
  late String? centroCostos;


  LoginResponse(this.respuesta,this.clase,this.error,this.isAquarius,
  this.codigoUnicoTrabajador,this.nombres,this.cargoTrabajador,this.dni,
      this.centroCostos,this.centroCostosId);

  bool get _respuesta => this.respuesta!;
  String get _clase => this.clase!;
  String get _error => this.error!;
  bool get _isAquarius => this.isAquarius!;
  String get _codigoUnicoTrabajador => this.codigoUnicoTrabajador!;
  String get _nombre => this.nombres!;
  String get _cargoTrabajador => this.cargoTrabajador!;



  LoginResponse.fromJson(Map<String,dynamic> parsedJson){
    respuesta = parsedJson['respuesta'];
    clase = parsedJson['clase'];
    error = parsedJson['error'];
    isAquarius = parsedJson['is_aquarius'];
    codigoUnicoTrabajador = parsedJson['codigo_unico_trabajador'];
    nombres = parsedJson['nombres'];
    cargoTrabajador = parsedJson['cargo_trabajador'];
    dni = parsedJson['dni'];
    centroCostos = parsedJson['centro_costos'];
    centroCostosId = parsedJson['centro_costos_id'];
  }

}
