import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilView extends StatefulWidget {

  const PerfilView({super.key
  });

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {

  String? nombre;
  String? cargoTrabajador;
  String? dni;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombre = "";
    cargoTrabajador = "";
    dni = "";
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              formatoInicialesTrabajador(),
              SizedBox(height: 10,),
              formatoCampoDatos('Nombre y apellidos ', (nombre!)),
              formatoCampoDatos('Cargo',cargoTrabajador!),
              formatoCampoDatos('Documento identidad', dni!),

              botonCerrarSesion(),
            ],
          ),
        ),
      ),
    );
  }


  String crearIncialesTrabajador(String nombres){
    // En el dato de Nombre vienen con los dos nombre completos en la amyoria de casos
    var splitNombre=nombres.split(" ");

    var inicialNombre=splitNombre[0].substring(0,1);

    return inicialNombre;
  }

  formatoCampoDatos(String nombreCampo,String contenidoCampo){
    return Container(
      child: Column(
        children: [
          Text(nombreCampo,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
          SizedBox(height: 10,),
          Text(contenidoCampo,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  formatoInicialesTrabajador(){
    return CircleAvatar(
      backgroundColor: GeneralColor.mainColor,
      radius: Constants.avatarRadius,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
          child: Text(crearIncialesTrabajador(nombre!),style: TextStyle(color: Colors.white),)
      ),
    );
  }

  botonCerrarSesion(){
    return ElevatedButton(
      onPressed: cerrarSesion,
      child:Text('Cerrar sesión'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // // foreground
      ),
    );
  }

  void cerrarSesion() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()));

    });
  }

  initSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    nombre = prefs.getString('NOMBRE')!;
    cargoTrabajador = prefs.getString('CARGO_TRABAJADOR')!;
    dni = prefs.getString('DNI')!;
  }

}
