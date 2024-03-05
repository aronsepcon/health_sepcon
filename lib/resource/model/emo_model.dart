class EmoModel {
  late String? tipo;
  late bool? hasDocument;
  late String? fecha;
  late String? mensaje;
  late bool? validated;
  late String? adjunto;
  late String? vigencia;
  late String? msj_vigencia;
  late bool? validate_vigencia;
  late String? motivo_vigencia;

  EmoModel(this.tipo, this.hasDocument, this.fecha, this.mensaje, this.motivo_vigencia,
      this.validated, this.adjunto, this.vigencia, this.msj_vigencia, this.validate_vigencia);

  String get _tipo => this.tipo!;

  bool get _hasDocument => this.hasDocument!;

  String get _fecha => this.fecha!;

  String get _mensaje => this.mensaje!;

  bool get _validated => this.validated!;

  String get _adjunto => this.adjunto!;

  String get _vigencia => this.vigencia!;
  
  String get _msj_vigencia => this.msj_vigencia!;

  bool get _validate_vigencia => this.validate_vigencia!;

  String get _motivo_vigencia => this.motivo_vigencia!;

  EmoModel.fromJson(Map<String, dynamic> formatJson) {
    tipo = formatJson['tipo']!;
    hasDocument = formatJson['has_document']!;
    fecha = formatJson['fecha'] ?? "";
    mensaje = formatJson['mensaje']!;
    validated = formatJson['validated'] ?? false;
    adjunto = formatJson['adjunto'];
    vigencia = formatJson['vigencia'];
    msj_vigencia = formatJson['msj_vigencia'];
    validate_vigencia = formatJson['validate_vigencia'];
    motivo_vigencia = formatJson['motivo_vigencia'];
  }
}
