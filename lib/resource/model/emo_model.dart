class EmoModel {
  late String? tipo;
  late bool? hasDocument;
  late bool? respuesta;
  late String? mensaje;
  late String? clase;

  EmoModel(
      this.tipo, this.hasDocument, this.respuesta, this.mensaje, this.clase);

  String get _tipo => this.tipo!;

  bool get _hasDocument => this.hasDocument!;

  bool get _respuesta => this.respuesta!;

  String get _mensaje => this.mensaje!;

  String get _clase => this.clase!;

  EmoModel.fromJson(Map<String, dynamic> formatJson) {
    tipo = formatJson['tipo']!;
    hasDocument = formatJson['has_document']!;
    respuesta = formatJson['respuesta']!;
    clase = formatJson['clase']!;
    mensaje = formatJson['mensaje']!;
  }
}
