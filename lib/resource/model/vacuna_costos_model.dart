class VacunaCostosModel{
  late List<String> vacunas;

  VacunaCostosModel(this.vacunas);

  VacunaCostosModel.fromJson(Map<String,dynamic> formatJson){
    vacunas =  parseVacuna(formatJson['vacunas']);
  }

  List<String> parseVacuna(List<dynamic> parsed){
    return parsed.map<String>((json)=> json.toString()).toList();
  }

}