class CentroCostosModel{

  String? id;
  String? nombre;
  String? codigo;

  CentroCostosModel(this.id,this.nombre,this.codigo);

  String get _id => this.id!;
  String get _nombre => this.nombre!;
  String get _codigo => this.codigo!;

  CentroCostosModel.fromJson(Map<String,dynamic> jsonFormat){
    id = jsonFormat['id'];
    nombre = jsonFormat['nombre'];
    codigo = jsonFormat['codigo'];
  }
}