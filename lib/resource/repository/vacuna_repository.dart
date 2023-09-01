import 'package:sepcon_salud/resource/api/vacuna_api.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';

class VacunaRepository{

  var vacunaApi = VacunaApi();

  Future<DocumentVacunaModel?> vacunaByDocument(String documento) =>
      vacunaApi.vacunaByDocument(documento);
}