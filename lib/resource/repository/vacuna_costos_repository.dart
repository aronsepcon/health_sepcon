import 'package:sepcon_salud/resource/api/vacuna_costos_api.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';

class VacunaCostosRepository{

  final vacunaCostosApi = VacunaCostosApi();

  Future<VacunaCostosModel?> fetchVacunaByCentroCostos(String? centroCostosId) =>
      vacunaCostosApi.fetchVacunaByCentroCostos(centroCostosId);
}