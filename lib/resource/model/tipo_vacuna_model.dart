class TipoVacunaModel{
  late String? name;
  late String? estado;
  late bool? validated;
  late bool? hasDocument;

  TipoVacunaModel(this.name,this.estado,this.validated,this.hasDocument);

  String get _name => this.name!;
  String get _estado => this.estado!;
  bool get _validated => this.validated!;
  bool get _hasDocument => this.hasDocument!;

  TipoVacunaModel.fromJson(Map<String,dynamic> formatJson){
    name = formatJson['Name'];
    estado = formatJson['estado'];
    validated = formatJson['validated'];
    hasDocument = formatJson['has_document'];

  }
}
