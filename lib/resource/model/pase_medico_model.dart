class PaseMedicoModel{

  late String? tipo;
  late bool? hasDocument;
  late String? clase;
  late String? adjunto;
  late String? error;
  late bool? validated;
  late String? mensaje;
  late String? vigencia;
  late String? motivo;
  late String? estado;
  
  PaseMedicoModel(this.tipo,this.hasDocument,this.clase,this.adjunto,this.error,
      this.validated,this.mensaje,this.vigencia, this.motivo, this.estado);

  String get _tipo => this.tipo!;
  bool get _hasDocument => this.hasDocument!;
  String get _clase => this.clase!;
  String get _adjunto => this.adjunto!;
  String get _error => this.error!;
  bool get _validated => this.validated!;
  String get _mensaje => this.mensaje!;
  String get _vigencia => this.vigencia!;
  String get _motivo => this.motivo!;
  String get _estado => this.estado!;

  PaseMedicoModel.fromJson(Map<String,dynamic> formatJson){
    tipo = formatJson['tipo'] ?? "";
    hasDocument = formatJson['has_document'] ?? false;
    clase = formatJson['clase'] ?? "";
    adjunto = formatJson['adjunto'] ?? "";
    validated = formatJson['validated'] ?? false;
    mensaje = formatJson['mensaje'] ?? "";
    vigencia = formatJson['vigencia'] ?? "";
    motivo = formatJson['motivo'] ?? "";
    estado = formatJson['estado'].toString() ?? "";
  }

}