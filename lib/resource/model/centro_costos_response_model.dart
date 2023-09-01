class CentroCostosResponse{

  late bool? respuesta;
  late String? message;
  late int? status;

  CentroCostosResponse(this.respuesta,this.message,this.status);

  bool get _respuesta => this.respuesta!;
  String get _message => this.message!;
  int get _status => this.status!;

  CentroCostosResponse.fromJson(Map<String,dynamic> parsedJson){
    respuesta = parsedJson['respuesta'];
    message = parsedJson['message'];
    status = parsedJson['status_code'];
  }

}