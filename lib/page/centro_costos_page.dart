import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/resource/model/centro_costos_model.dart';
import 'package:sepcon_salud/resource/model/centro_costos_response_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/repository/centro_costos_repository.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CentroCostosPage extends StatefulWidget {

  final List<CentroCostosModel> listCentroCostos;
  final LoginResponse? loginResponse;

 CentroCostosPage({super.key,
    required this.listCentroCostos,required this.loginResponse});

  @override
  State<CentroCostosPage> createState() => _CentroCostosPageState();
}

class _CentroCostosPageState extends State<CentroCostosPage> {
  
  CentroCostosModel centroCostosModel = CentroCostosModel("0","LIMA", "0200");
  List<String> centroCostos = [];
  String defaultCentro = "LIMA";
  late CentroCostosRepository centroCostosRepository;

  bool isLoading = false;

  //late List<CentroCostosModel> listCentroCostos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    centroCostosRepository = CentroCostosRepository();

    for(CentroCostosModel centroCostosModel in widget.listCentroCostos){
      centroCostos.add(centroCostosModel.nombre.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: isLoading ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [getLoadEffect()],
            ): Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(
                  height: 50,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Centro de costos",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                widgetDropDownProyectos(),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    registerCC();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 15,bottom: 15),
                    //height: 50,
                    decoration: BoxDecoration(
                        color: GeneralColor.mainColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text(
                          "Siguiente",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                ),


              ],
            ) ,
          ),
        ),
      ),
    );
  }

  Widget widgetDropDownProyectos() {
    Widget widget = DropdownButtonFormField(
        style: const TextStyle(color: Colors.black, fontSize: 16),
        iconEnabledColor: GeneralColor.mainColor,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GeneralColor.grayBoldColor))),
        hint: const  Text(
          'Escoger centro de costos',
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        value: defaultCentro,
        items: centroCostos.map((String product) {
          return DropdownMenuItem<String>(
            value: product,
            child: Container(
              width: 200,
              child: Text(
                product,
              ),
            ),
          );
        }).toList(),
        validator: (value) => value == null ? 'seleccionar un centro de costos' : null,
        onChanged: (value){
          setState(() {
           defaultCentro = value!;
          });
        });

    return Container(
      child: widget,
    );
  }

  routeHome(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage()));
  }

  widgetErrorDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Text(message,style: TextStyle(fontSize: 16,),),
        );
      },
    );
  }

  void registerCC() async {

    setState(() {
      isLoading = true;
    });

    String id = "";

    for(CentroCostosModel centroCostosModel in widget.listCentroCostos){
      if(centroCostosModel.nombre!.contains(defaultCentro)){
        id = centroCostosModel.codigo!;
      }
    }

    CentroCostosResponse? centroCostosResponse =
    await centroCostosRepository.registerCentroCostos(widget.loginResponse!.dni,id);

    if(centroCostosResponse != null){
      setState(() {
        isLoading = false;
        routeHome();
      });
    }else{
      setState(() {
        isLoading = false;
        widgetErrorDialog("Error en el sistema");
      });
    }
  }


}
