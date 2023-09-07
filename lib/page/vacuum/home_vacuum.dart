import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/page/vacuum/carousel_vacuum.dart';
import 'package:sepcon_salud/page/vacuum/certificado_vacuna.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/dosis_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/model/refuerzo_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeVacuum extends StatefulWidget {
  const HomeVacuum({super.key});
  @override
  State<HomeVacuum> createState() => _HomeVacuumState();
}

class _HomeVacuumState extends State<HomeVacuum> {

  List<String> list = [
    'Fiebre Amarilla',
    'Difteria',
    'Hepatitis A',
    'Hepatitis B',
    'Influenza',
    'Polio',
    'Trivirica',
    'Rabia',
    'Tifoidea',
    'Neumococo',
  ];
  late File filePdf;

  final List<String> imgList = [
    'assets/vaccine/vacuna_1.png',
    'assets/vaccine/vacuna_2.jpeg',
    'assets/vaccine/vacuna_2.jpeg',
    'assets/vaccine/vacuna_2.jpeg',
    'assets/document/document_frontal_4.png',
  ];
  final List<String> titleList = [
    '1. Posición correcta del documento',
    '2. Tomar foto',
    '3. Verificar foto',
    '4. Guardar foto',
    '5. Empezar a tomar la foto',
  ];

  String path = "";
  late File file;
  late DocumentVacunaModel? documentVacunaModel;
  late LocalStore localStore;
  bool showView = false;
  late List<VacunaModel> listVacunaModel;
  late List<VacunaModel> listRequiredVacuum;
  late List<VacunaModel> listNotRequiredVacuum;
  late VacunaCostosModel? vacunaCostosModel;
  late LoginResponse? loginResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localStore = LocalStore();
    listVacunaModel = [];
    listRequiredVacuum = [];
    listNotRequiredVacuum = [];
    fetchDataLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: showView ? Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vacunas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.my_location),
                      Text(
                         loginResponse!.centroCostos!,
                        style: TextStyle(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // INDICATOR
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GeneralColor.mainColor,
                    ),
                    height: 120,
                    child: Padding(
                      padding:EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Usted cuenta con el certificado de vacunas'
                                  ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: (){
                                    certificadoVacuna();
                                  },
                                  child: Row(
                                    children: [
                                      Text('Ver certificado ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontStyle: FontStyle.italic),),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          Padding(
                              padding:EdgeInsets.only(left: 15),
                              child: Icon(Icons.document_scanner_rounded,size: 50,color: Colors.white,)
                          ),

                        ],
                      ),
                    ),
                  ),

                  // DOCUMENTS
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Vacunas obligatorias",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Column(
                    children: widgetListTipos(listRequiredVacuum)
                  ),
                  const SizedBox(height: 20,),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Vacunas No obligatorias",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Column(
                      children: widgetListTipos(listNotRequiredVacuum)
                  )


                ],
              ),
            ) : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [getLoadEffect()],
              ),
            ),
          )),
    );
  }

  List<Widget> widgetListTipos(List<VacunaModel> listVacunaModel){
    List<Widget> listTipos = [];

    for(VacunaModel vacunaModel in listVacunaModel){
      Widget widget = Column(
        children: [
          const SizedBox(height: 10,),

          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: GeneralColor.grayBoldColor,
              ),
              child: ListTile(
                onTap: (){
                  widgetBottomSheet(vacunaModel);
                },
                leading:  vacunaModel.validated! ?
                const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                    : const Icon(Icons.warning_amber,color: Colors.amber,),
                title: Text(vacunaModel.nombre!),
                trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
              )
          ),

        ],
      );
      listTipos.add(widget);
    }

    return listTipos;
  }

  widgetBottomSheet(VacunaModel vacunaModel){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 25,right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close,size: 35,)
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vacunaModel.nombre!,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dosis",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(children:
                  widgetListDosis(vacunaModel.vacunaDetalle!.dosis)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Refuerzos",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(children:
                  widgetListRefuerzo(vacunaModel.vacunaDetalle!.refuerzos)),

                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      routePDFViewer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                            color: GeneralColor.mainColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                            child: Text(
                              'Actualizar vacuna',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      isScrollControlled:true,
    );
  }

  List<Widget> widgetListDosis(List<DosisModel> listDosisModel){
    List<Widget> listTipos = [];

    for(DosisModel dosisModel in listDosisModel){
      Widget widget = Column(
        children: [
          ListTile(
            leading: Text("#${dosisModel.nDosis.toString()}"),
            title: Text(dosisModel.fecha != null ? dosisModel.fecha! : "fecha pendiente"),
            trailing: dosisModel.estadoDosis! != "PENDIENTE_REVISAR" ?
            const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                : const Icon(Icons.warning_amber,color: Colors.amber,),
          ),
        ],
      );
      listTipos.add(widget);
    }

    return listTipos;
  }

  List<Widget> widgetListRefuerzo(List<RefuerzoModel> listRefuerzoModel){
    List<Widget> listTipos = [];

    for(RefuerzoModel refuerzoModel in listRefuerzoModel){
      Widget widget = Column(
        children: [
          ListTile(
            leading: Text("#${refuerzoModel.nDosis.toString()}"),
            title: Text(refuerzoModel.proximaFecha != null ?
    refuerzoModel.proximaFecha! : "fecha pendiente"),
            trailing: refuerzoModel.estado! != "PENDIENTE_REVISAR" ?
            const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                : const Icon(Icons.warning_amber,color: Colors.amber,),
          ),

        ],
      );
      listTipos.add(widget);
    }

    return listTipos;
  }

  routePDFViewer(){
    List<File> listfile = [];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>CarouselVacuum(
              titlePage: "Vacunas",
              imgList: imgList, titleList: titleList)));
  }

  certificadoVacuna(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CertificadoVacuna(urlPdf: path,)));
  }

  fetchDataLocal() async {
    documentVacunaModel = await localStore.fetchVacunaGeneral();
    vacunaCostosModel = await localStore.fetchVacunaCostos();
    loginResponse = await localStore.fetchUser();
    if(documentVacunaModel != null && loginResponse != null
        && vacunaCostosModel != null){
      setState(() {
        showView = true;
        listVacunaModel = documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!;
        generateTwoListVacunas();
        path = documentVacunaModel!.vacunaGeneralModel!.tiposVacunas![0]
            .adjunto!;
      });
    }
  }

  generateTwoListVacunas(){
    for(VacunaModel vacunaModel in
    documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!){
      for(String vacuna in vacunaCostosModel!.vacunas){
        if(vacuna == vacunaModel.nombre){
          listRequiredVacuum.add(vacunaModel);
        }else{
          listNotRequiredVacuum.add(vacunaModel);
        }
      }
    }
  }
}
