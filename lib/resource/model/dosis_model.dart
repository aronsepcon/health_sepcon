class DosisModel{

  late String? nombre;
  late int? nDosis;
  late String? documento;
  late String? estadoDosis;
  late String? fecha;

  DosisModel(this.nombre,this.nDosis,this.documento,this.estadoDosis,this.fecha);

  String get _nombre => this.nombre!;
  int get _nDosis => this.nDosis!;
  String get _documento => this.documento!;
  String get _estadoDosis => this.estadoDosis!;
  String get _fecha => this.fecha!;

  DosisModel.fromJson(Map<String,dynamic> formatJson){
    nombre = formatJson['nombre'];
    nDosis = formatJson['n_dosis'];
    documento = formatJson['documento'];
    estadoDosis = formatJson['estado_dosis'];
    fecha = formatJson['fecha'];
  }
}