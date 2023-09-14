class DocumentoIdentidadModel{
  late bool? hasDocument;
  late String? tipo;
  late String? clase;
  late String? error;
  late bool? validated;
  late String? mensaje;
  late String? adjunto;

  DocumentoIdentidadModel(this.hasDocument,this.tipo,this.clase,this.error,
      this.validated,this.mensaje,this.adjunto);

  bool get _hasDocument => this.hasDocument!;
  String get _tipo => this.tipo!;
  String get _clase => this.clase!;
  String get _error => this.error!;
  bool get _validated => this.validated!;
  String get _mensaje => this.mensaje!;
  String get _adjunto => this.adjunto!;

  DocumentoIdentidadModel.fromJson(Map<String,dynamic> formatJson){
    hasDocument = formatJson['has_document']!;
    tipo = formatJson['tipo']!;
    clase = formatJson['clase']!;
    error = formatJson['error']!;
    validated = formatJson['validated']!;
    mensaje = formatJson['mensaje']!;
    if (formatJson['adjunto'] == null) {
      adjunto = "";
    } else {
      adjunto = formatJson['adjunto'];
    }
  }
}

