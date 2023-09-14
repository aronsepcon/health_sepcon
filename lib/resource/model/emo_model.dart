class EmoModel {
  late String? tipo;
  late bool? hasDocument;
  late String? fecha;
  late String? mensaje;
  late bool? validated;
  late String? adjunto;

  EmoModel(this.tipo, this.hasDocument, this.fecha, this.mensaje,
      this.validated, this.adjunto);

  String get _tipo => this.tipo!;

  bool get _hasDocument => this.hasDocument!;

  String get _fecha => this.fecha!;

  String get _mensaje => this.mensaje!;

  bool get _validated => this.validated!;

  String get _adjunto => this.adjunto!;

  EmoModel.fromJson(Map<String, dynamic> formatJson) {
    tipo = formatJson['tipo']!;
    hasDocument = formatJson['has_document']!;
    fecha = formatJson['fecha']!;
    mensaje = formatJson['mensaje']!;
    validated = formatJson['validated']!;
    adjunto = formatJson['adjunto']!;
  }
}
