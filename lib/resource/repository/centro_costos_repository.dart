import 'package:sepcon_salud/resource/api/centro_costos_api.dart';
import 'package:sepcon_salud/resource/model/centro_costos_model.dart';
import 'package:sepcon_salud/resource/model/centro_costos_response_model.dart';

class CentroCostosRepository{

  var centroCostosApi = CentroCostosApi();

  Future<List<CentroCostosModel>> listCentroCostos() =>
      centroCostosApi.listCentroCostos();

  Future<CentroCostosResponse?> registerCentroCostos(String? document,String id) =>
      centroCostosApi.registerCentroCostos(document!, id);
}