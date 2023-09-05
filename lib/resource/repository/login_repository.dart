import 'package:sepcon_salud/resource/api/login_api.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';

class LoginRepository{

  final loginApi = LoginApi();

  Future<LoginResponse?> authenticate(String document,String password) =>
      loginApi.fetchLogin(document , password);

}