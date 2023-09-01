import 'package:sepcon_salud/resource/api/vacuna_api.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';

class VacunaRepository{

  var vacunaApi = VacunaApi();

  Future<VacunaModel?> vacunaByDocument(String documento) =>
      vacunaApi.vacunaByDocument(documento);
}