class RefuerzoModel{

  late String? nombre;
  late int? nDosis;
  late String? documento;
  late String? estado;
  late String? proximaFecha;

  RefuerzoModel(this.nombre,this.nDosis,this.documento,this.estado,this.proximaFecha);

  String get _nombre => this.nombre!;
  int get _nDosis => this.nDosis!;
  String get _documento => this.documento!;
  String get _estado => this.estado!;
  String get _proximaFecha => this.proximaFecha!;

  RefuerzoModel.fromJson(Map<String,dynamic> formatJson){
    nombre = formatJson['nombre'];
    nDosis = formatJson['n_dosis'];
    documento = formatJson['documento'];
    estado = formatJson['estado'];
    proximaFecha = formatJson['proxima_fecha'];
  }
}