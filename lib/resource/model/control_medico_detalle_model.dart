class ControlMedicoDetalleModel{
  late bool? hasDocument;
  late String? tipo;
  late bool? validated;
  late String? id;
  late String? fechaReg;
  late String? nombreDoc;

  ControlMedicoDetalleModel(this.hasDocument,this.tipo,this.validated,this.id,
      this.fechaReg, this.nombreDoc);

  bool get _hasDocument => this.hasDocument!;
  String get _tipo => this.tipo!;
  bool get _validated => this.validated!;
  String get _id => this.id!;
  String get _fechaReg => this.fechaReg!;
  String get _nombreDoc => this.nombreDoc!;

  ControlMedicoDetalleModel.fromJson(Map<String,dynamic> fromJson){
    hasDocument = fromJson['has_document'];
    tipo = fromJson['tipo'];
    validated = fromJson['validated'];
    id = fromJson['id'];
    fechaReg = fromJson['fechareg'];
    nombreDoc = fromJson['nombre_doc'];
  }
}