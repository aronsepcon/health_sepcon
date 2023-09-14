import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  String? nombre;
  String? cargoTrabajador;
  String? dni;
  String? centroCostos;
  late bool isLoading;
  late LocalStore localStore;
  late  LoginResponse? loginResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombre = "";
    cargoTrabajador = "";
    dni = "";
    initVariable();
    findUserLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [getLoadEffect()],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    formatoInicialesTrabajador(),
                    SizedBox(
                      height: 10,
                    ),
                    formatoCampoDatos('Nombre y apellidos ', (nombre!)),
                    formatoCampoDatos('Cargo', cargoTrabajador!),
                    formatoCampoDatos('Documento identidad', dni!),
                    formatoCampoDatos('Centro de costos', centroCostos!),

                    buttonLogout(),
                  ],
                ),
        ),
      ),
    );
  }

  String crearIncialesTrabajador(String nombres) {
    // En el dato de Nombre vienen con los dos nombre completos en la amyoria de casos
    var splitNombre = nombres.split(" ");

    var inicialNombre = splitNombre[0].substring(0, 1);

    return inicialNombre;
  }

  formatoCampoDatos(String nombreCampo, String contenidoCampo) {
    return Container(
      child: Column(
        children: [
          Text(
            nombreCampo,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            contenidoCampo,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  formatoInicialesTrabajador() {
    return CircleAvatar(
      backgroundColor: GeneralColor.mainColor,
      radius: Constants.avatarRadius,
      child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(Constants.avatarRadius)),
          child: Text(
            crearIncialesTrabajador(nombre!),
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  buttonLogout() {
    return ElevatedButton(
      onPressed: logOut,
      child: const Text('Cerrar sesión'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // // foreground
      ),
    );
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false);
    });
  }


  initVariable() {
    isLoading = false;
    localStore = LocalStore();
  }


  findUserLocalStorage() async {
    LoginResponse? loginResponse = await localStore.fetchUser();
    if(loginResponse != null){
      setState(() {
        nombre = loginResponse.nombres;
        cargoTrabajador = loginResponse.cargoTrabajador;
        dni = loginResponse.dni;
        centroCostos = loginResponse.centroCostos!;
      });
    }
  }
}
