class PaseMedicoModel{
  late String? tipo;
  late bool? hasDocument;
  late String? clase;
  late String? adjunto;
  late String? error;
  late bool? validated;
  late String? mensaje;

  PaseMedicoModel(this.tipo,this.hasDocument,this.clase,this.adjunto,this.error,
      this.validated,this.mensaje);

  String get _tipo => this.tipo!;
  bool get _hasDocument => this.hasDocument!;
  String get _clase => this.clase!;
  String get _adjunto => this.adjunto!;
  String get _error => this.error!;
  bool get _validated => this.validated!;
  String get _mensaje => this.mensaje!;

  PaseMedicoModel.fromJson(Map<String,dynamic> formatJson){
    tipo = formatJson['tipo']!;
    hasDocument = formatJson['has_document']!;
    clase = formatJson['clase']!;
    adjunto = formatJson['adjunto']!;
    error = formatJson['error']!;
    validated = formatJson['validated']!;
    mensaje = formatJson['mensaje']!;
  }
}