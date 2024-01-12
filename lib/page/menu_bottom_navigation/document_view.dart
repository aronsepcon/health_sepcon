import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/control_medico/control_medico_home_page.dart';
import 'package:sepcon_salud/page/control_medico/control_medico_init_page.dart';
import 'package:sepcon_salud/page/covid/covid_home_page.dart';
import 'package:sepcon_salud/page/covid/covid_init_page.dart';
import 'package:sepcon_salud/page/document_identidad/document_home_page.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_home_page.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_init_page.dart';
import 'package:sepcon_salud/page/vacuum/vacuum_home_page.dart';
import 'package:sepcon_salud/page/vacuum/vacuum_init_page.dart';
import 'package:sepcon_salud/resource/model/control_medico_model.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/repository/vacuna_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/circular_animation.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';
import 'package:sepcon_salud/util/route.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key});

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView>  with SingleTickerProviderStateMixin{
  
  late AnimationController progressController;
  late Animation animation;
  late LocalStore localStore;
  late DocumentVacunaModel? documentVacuumModel;
  late VacunaCostosModel? vacuumCostosModel;
  late ControlMedicoModel? controlMedicoModel;
  late LoginResponse? loginResponse;
  late String path;
  late bool showHome;
  late double porcentaje;
  late int documentosCompletos , totalDocumentos;
  var stateDcumentMap, stateFlowMap;
  late VacunaModel covidModel;

  bool STATE_DOCUMENTO_IDENTIDAD = false;
  bool STATE_VACUNA = false;
  bool STATE_PASE_MEDICO = false;
  bool STATE_COVID19 = false;
  bool STATE_CONTROL_MEDICO = false;

  String KEY_DOCUMENTO_IDENTIDAD = "DOCUMENTO_IDENTIDAD";
  String KEY_VACUNA = "VACUNA";
  String KEY_PASE_MEDICO = "PASE_MEDICO";
  String KEY_COVID19 = "COVID19";
  String KEY_CONTROL_MEDICO = "CONTROL_MEDICO";

  bool FLOW_DOCUMENTO_IDENTIDAD = false;
  bool FLOW_VACUNA = false;
  bool FLOW_PASE_MEDICO = false;
  bool FLOW_COVID19 = false;
  bool FLOW_CONTROL_MEDICO = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVariable();
    findUserAndDocumentAndCostosLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: !showHome ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [getLoadEffect()],
              ),
            ) : Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  // HEADER
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        GeneralWord.welcomeMessageHome,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                     Row(
                       children: [
                         const Icon(
                           Icons.notifications_none,
                           color: Colors.black,
                         ),
                         GestureDetector(
                           onTap: () async {
                             setState(() {
                               showHome = false;
                             });
                             VacunaRepository vacunaRepository = VacunaRepository();
                             DocumentVacunaModel? vacunaModel =
                             await vacunaRepository.vacunaByDocument(loginResponse!.dni!);

                             if(vacunaModel != null){
                               findUserAndDocumentAndCostosLocalStorageUpdate();
                             }

                           },
                           child: const Icon(
                             Icons.refresh,
                             color: Colors.black,
                           ),
                         )
                       ],
                     )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loginResponse!.nombres!.split(" ")[0],
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // INDICATOR
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GeneralColor.mainColor,
                    ),
                    height: 120,
                    child: Padding(
                      padding:const EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(GeneralWord.titleIndicatorHome
                                  ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.book,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text('${documentosCompletos.toString()} / ${totalDocumentos.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          CustomPaint(
                            foregroundPainter: CircleProgress(animation.value.toDouble()),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(child: Text(
                                "${animation.value.toInt()}%",style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),)),
                            ),
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
                        GeneralWord.titleDocumentHome,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                        onTap: (){
                          FLOW_DOCUMENTO_IDENTIDAD ?
                          routeDocumentoIdentidadHomePage()
                          :routeDocumentoIdentidadInitPage();
                        },
                        leading: STATE_DOCUMENTO_IDENTIDAD ?
                        const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                            : const Icon(Icons.warning_amber,color: Colors.amber,),
                        title: const  Text(GeneralWord.identityDocumentHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                          onTap: (){
                            FLOW_VACUNA ?
                            routeVacuumHomePage()
                            :routeVacuumInitPage();
                          },
                        leading: STATE_VACUNA ?
                        const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                            : const Icon(Icons.warning_amber,color: Colors.amber,),
                        title: const   Text(GeneralWord.vacuumHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                          onTap: (){
                            FLOW_PASE_MEDICO ?
                            routePaseMedicoHomePage()
                                : routePaseMedicoInitPage();
                          },
                          leading: STATE_PASE_MEDICO ?
                          const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                              : const Icon(Icons.warning_amber,color: Colors.amber,),
                          title: const  Text(GeneralWord.passMedicHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                          onTap: (){
                            FLOW_CONTROL_MEDICO ? routeHomeControlMedico()
                            : routeInitControlMedico();
                          },
                        leading: STATE_CONTROL_MEDICO ?
                        const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                            : const Icon(Icons.warning_amber,color: Colors.amber,),
                        title: const Text(GeneralWord.controlMedicHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),

                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                        onTap: (){
                          FLOW_COVID19 ? routeHomeCovidPage()
                              : routeInitCovidPage();
                        },
                        leading:  STATE_COVID19 ?
                        const Icon(Icons.check_circle,color: GeneralColor.greenColor,)
                            : const Icon(Icons.warning_amber,color: Colors.amber,),
                        title: const Text(GeneralWord.covidHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GeneralColor.grayBoldColor
                    ),
                    child: const ListTile(
                      title: Text(GeneralWord.emoHome),
                      trailing: Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  initVariable(){
    localStore = LocalStore();
    showHome = false;
    porcentaje = 0.0;
    documentosCompletos = 0;
    totalDocumentos = 0;
    stateDcumentMap = <String,bool?>{};
    stateFlowMap = <String,bool?>{};
  }

  findUserAndDocumentAndCostosLocalStorage() async {
    documentVacuumModel = await localStore.fetchVacunaGeneral();
    loginResponse = await localStore.fetchUser();
    vacuumCostosModel = await localStore.fetchVacunaCostos();

    if(documentVacuumModel != null && loginResponse != null
        && vacuumCostosModel != null){
      animatePorcentaje(validatePorcentaje());
      setState(() {
        showHome = true;
        validateStateDocument();
        validateFlowDocument();
      });
    }
  }

  findUserAndDocumentAndCostosLocalStorageUpdate() async {
    documentVacuumModel = await localStore.fetchVacunaGeneral();
    loginResponse = await localStore.fetchUser();
    vacuumCostosModel = await localStore.fetchVacunaCostos();

    if(documentVacuumModel != null && loginResponse != null
        && vacuumCostosModel != null){
      setState(() {
        showHome = true;
        validateStateDocument();
        validateFlowDocument();
      });
    }
  }

 double validatePorcentaje(){

    var porcentajeMap = <String,bool?>{};

    porcentajeMap[KEY_DOCUMENTO_IDENTIDAD] =
        documentVacuumModel!.documentoIdentidadModel!.validated!;
    porcentajeMap[KEY_PASE_MEDICO] =
        documentVacuumModel!.paseMedicoModel!.validated;

    for(VacunaModel vacunaModel in documentVacuumModel!.vacunaGeneralModel!.tiposVacunas!){
      for(String vacuna in vacuumCostosModel!.vacunas){
        if(vacuna == vacunaModel.nombre){
            porcentajeMap[vacunaModel.nombre!] = vacunaModel.validated;
        }
      }

      if(vacunaModel.nombre == "Covid19"){
        porcentajeMap[KEY_COVID19] =
        vacunaModel.validated!;
      }
    }

    porcentajeMap[KEY_CONTROL_MEDICO] = documentVacuumModel!.controlMedicoModel!.validated!;

    porcentajeMap.forEach((key, value) {
      if(value!){
        documentosCompletos++;
      }
      totalDocumentos++;
    });

    porcentaje = (documentosCompletos.toDouble() / totalDocumentos.toDouble())*100.0;
    
    return porcentaje;
  }

  animatePorcentaje(double porcentaje){
    progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween(begin: 0.0, end: porcentaje).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
    progressController.forward();
  }

  validateStateDocument(){

    int tempTotal = vacuumCostosModel!.vacunas.length;
    int tempComplete = 0;
    double tempPorcentaje = 0;

    STATE_DOCUMENTO_IDENTIDAD =
    documentVacuumModel!.documentoIdentidadModel!.validated!;

    STATE_PASE_MEDICO =
        documentVacuumModel!.paseMedicoModel!.validated!;

    STATE_CONTROL_MEDICO = documentVacuumModel!.controlMedicoModel!.validated!;

    // VALIDATE VACUUM
    for(VacunaModel vacunaModel in documentVacuumModel!.vacunaGeneralModel!.tiposVacunas!){
      for(String vacuna in vacuumCostosModel!.vacunas){
        if(vacuna == vacunaModel.nombre){
          if(vacunaModel.validated!){
            tempComplete++;
          }
        }
      }

      if(vacunaModel.nombre == "Covid19"){
        STATE_COVID19 =
            vacunaModel.validated!;
      }
    }

    tempPorcentaje = (tempComplete.toDouble() / tempTotal.toDouble()) * 100.0;

    if(tempPorcentaje == 100.0){
      STATE_VACUNA = true;
    }

  }

  validateFlowDocument(){

    FLOW_DOCUMENTO_IDENTIDAD =
    documentVacuumModel!.documentoIdentidadModel!.adjunto!.isNotEmpty
        ? true : false;

    FLOW_PASE_MEDICO =
    documentVacuumModel!.paseMedicoModel!.adjunto!.isNotEmpty
        ? true : false;

    FLOW_VACUNA = documentVacuumModel!.vacunaGeneralModel!.validated! == true ? true : false;
    //documentVacuumModel!.vacunaGeneralModel!.documentGeneral!.isNotEmpty
     //   ? true : false;

    FLOW_CONTROL_MEDICO = documentVacuumModel!.controlMedicoModel!.controlMedico!
        .isNotEmpty ? true : false;

    for(VacunaModel vacunaModel in documentVacuumModel!.vacunaGeneralModel!.tiposVacunas!){
      if(vacunaModel.nombre == "Covid19"){
        covidModel = vacunaModel;
        FLOW_COVID19 = vacunaModel.adjunto!.isNotEmpty ? true : false;
      }
    }

  }

  routeDocumentoIdentidadInitPage(){
    Navigator.push(
        context, RouteGenerator.generateRoute(
        const RouteSettings(name: '/documentoIdentidadInit')));
  }

  routeDocumentoIdentidadHomePage(){
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => DocumentHomePage(
            documentoIdentidadModel: documentVacuumModel!.documentoIdentidadModel!)));
  }

  routeVacuumInitPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const VacuumInitPage()));
  }

  routeVacuumHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VacuumHomePage(
              vacunaGeneralModel: documentVacuumModel!.vacunaGeneralModel!,)));
  }

  routePaseMedicoInitPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaseMedicoInitPage()));
  }

  routePaseMedicoHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            PaseMedicoHomePage(paseMedicoModel: documentVacuumModel!.paseMedicoModel! ,)));
  }

  routeInitCovidPage(){
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => const CovidInitPage()));
  }

  routeHomeCovidPage(){
    log(covidModel.nombre!);
    log(covidModel.adjunto!);
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) =>  CovidHomePage(covidModel: covidModel,)));
  }

  routeInitControlMedico(){
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) =>  const ControlMedicoInitPage()));
  }

  routeHomeControlMedico(){
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) =>  ControlMedicoHomePage(
          controlMedicoModel:documentVacuumModel!.controlMedicoModel! ,)));
  }

}
