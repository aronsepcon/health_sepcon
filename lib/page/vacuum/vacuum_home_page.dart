import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/vacuum/vacuum_carousel_page.dart';
import 'package:sepcon_salud/page/vacuum/vacuum_certificado_page.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/dosis_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/model/refuerzo_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_detalle_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_general_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class VacuumHomePage extends StatefulWidget {
  final VacunaGeneralModel vacunaGeneralModel;

  const VacuumHomePage({super.key,required this.vacunaGeneralModel});
  @override
  State<VacuumHomePage> createState() => _VacuumHomePageState();
}

class _VacuumHomePageState extends State<VacuumHomePage> {

  late File filePdf;

  //String path = "";
  late File file;
  late DocumentVacunaModel? documentVacunaModel;
  late LocalStore localStore;
  bool showView = false;
  late List<VacunaModel> listVacunaModel;
  late List<VacunaModel> listRequiredVacuum;
  late List<VacunaModel> listNotRequiredVacuum;
  late VacunaCostosModel? vacunaCostosModel;
  late LoginResponse? loginResponse;
  late double? heightScreen;
  late double? widthScreen;
  late String? keyDocument;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localStore = LocalStore();
    listVacunaModel = [];
    listRequiredVacuum = [];
    listNotRequiredVacuum = [];
    keyDocument = Constants.KEY_CERTIFICADO_VACUNA;
    fetchDataLocal();
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
                        Constants.TITLE_CERTIFICADO_VACUNA,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  Container(
                    width: widthScreen!,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GeneralColor.mainColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined,size: 15,color: Colors.white,),
                        Text(
                          loginResponse!.centroCostos!,
                          style: TextStyle(fontSize: 12,color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
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
                    children: widgetListTipos(documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!,true)
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
                      children: widgetListTipos(documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!,false)
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

  List<Widget> widgetListTipos(List<VacunaModel> listVacunaModel,bool request){
    List<Widget> listTipos = [];

    for(VacunaModel vacunaModel in listVacunaModel){
          var test = vacunaModel.amountDay;
          print("la vigencia es $test");

      if(vacunaModel.requiredVacuum == request){
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
                  leading: statusVigenciaIcon(vacunaModel.vigenciaVacuna),
                  title: Text(vacunaModel.nomenclatura!),
                  subtitle:statusVigenciaMessage(vacunaModel.vigenciaVacuna,vacunaModel.amountDay!),
                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                )
            ),

          ],
        );
        listTipos.add(widget);
      }

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
                    height: 10,
                  ),

                  statusVigencia(vacunaModel.vigenciaVacuna,vacunaModel.amountDay!),
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
                      routePDFViewer(vacunaModel.nombre!);
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

  statusVigencia(VigenciaVacuna vigenciaVacuna,int amountDay){
    Widget widgetIcon = Container();
    if(vigenciaVacuna == VigenciaVacuna.empty){
      widgetIcon = const Row(
        children: [
          Icon(Icons.hourglass_empty),
          Text("No cuenta con ninguna vacuna registrada"),
        ],
      );
    }
    if(vigenciaVacuna == VigenciaVacuna.active){
      widgetIcon = const Row(
        children: [
          Icon(Icons.check_circle,color: GeneralColor.greenColor,),
          Text("Vigente",style: TextStyle(color: GeneralColor.greenColor,fontWeight: FontWeight.bold),),
        ],
      );
    }
    if(vigenciaVacuna == VigenciaVacuna.noActive){
      widgetIcon = Row(
        children: [
          Icon(Icons.error,color: Colors.red,),
          Text("Vencido : $amountDay día(s) ",style: TextStyle(color:  Colors.red,fontWeight: FontWeight.bold),),
        ],
      );
    }
    if(vigenciaVacuna == VigenciaVacuna.toExpire){
      widgetIcon = Row(
        children: [
          Icon(Icons.warning,color: Colors.amber,),
          Text("Por vencer : $amountDay día(s)",style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),),

    ],
      );
    }
    return widgetIcon;
  }

  statusVigenciaIcon(VigenciaVacuna vigenciaVacuna){
    Widget widgetIcon = Container();
    if(vigenciaVacuna == VigenciaVacuna.empty){
      widgetIcon = Icon(Icons.hourglass_empty);
    }
    if(vigenciaVacuna == VigenciaVacuna.active){
      widgetIcon = const Icon(Icons.check_circle,color: GeneralColor.greenColor,);
    }
    if(vigenciaVacuna == VigenciaVacuna.noActive){
      widgetIcon = const  Icon(Icons.error,color: Colors.red,);
    }
    if(vigenciaVacuna == VigenciaVacuna.toExpire){
      widgetIcon = const  Icon(Icons.warning,color: Colors.amber,);
    }
    return widgetIcon;
  }

  statusVigenciaMessage(VigenciaVacuna vigenciaVacuna,int amountDay){
    Widget widgetIcon = const Text("");
    if(vigenciaVacuna == VigenciaVacuna.noActive){
      widgetIcon = Text("$amountDay día(s) vencido");
    }
    if(vigenciaVacuna == VigenciaVacuna.toExpire){
      widgetIcon = Text("A $amountDay día(s) por vencer");
    }
    return widgetIcon;
  }



  List<Widget> widgetListDosis(List<DosisModel> listDosisModel){
    List<Widget> listTipos = [];

    for(DosisModel dosisModel in listDosisModel){
      Widget widget = Column(
        children: [
          ListTile(
            leading: Text("#${dosisModel.nDosis.toString()}"),
            title: Text(dosisModel.fecha != null ? dosisModel.fecha! : "-"),
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
    refuerzoModel.proximaFecha! : "-"),
          ),

        ],
      );
      listTipos.add(widget);
    }

    return listTipos;
  }

  routePDFViewer(String nomenclatura) async {
    bool result = await localStore.deleteKey(keyDocument!);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  VacuumCarouselPage(
              titlePage: Constants.TITLE_CERTIFICADO_VACUNA,
              imgList: Constants.imgListVacuum, titleList: Constants.titleListGeneral,
                nomenclatura: nomenclatura)));
  }

  certificadoVacuna(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VacuumCertificadoPage(
              vacunaGeneralModel: widget.vacunaGeneralModel ,)));
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
      });
    }
  }

  generateTwoListVacunas(){

    //editValue();
    //listNotRequiredVacuum = documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!;

    for(VacunaModel vacunaModel in
    documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!){
      for(String vacuna in vacunaCostosModel!.vacunas){
        if(vacuna == vacunaModel.nombre){
          //listRequiredVacuum.add(vacunaModel);
          vacunaModel.requiredVacuum = true;
        }
      }
    }

    /*for(VacunaModel vacunaModel in listRequiredVacuum){
      if(listNotRequiredVacuum.contains(vacunaModel)){
        listNotRequiredVacuum.remove(vacunaModel);
      }
    }*/

    validateDates(documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!);

    log("NOT REQUIRED");

    validateDates(listNotRequiredVacuum);
  }

  /*editValue(){
    for(VacunaModel vacunaModel in
    documentVacunaModel!.vacunaGeneralModel!.tiposVacunas!){
      if(vacunaModel.nombre == "HepatitisB"){
        vacunaModel.vacunaDetalle!.dosis[0].fecha = "2023-08-11";
        vacunaModel.vacunaDetalle!.dosis[1].fecha = "2023-09-11";
        vacunaModel.vacunaDetalle!.dosis[2].fecha = null;
      }
      if(vacunaModel.nombre == "Difteria"){
        vacunaModel.vacunaDetalle!.dosis[2].fecha = "2023-08-11";
        vacunaModel.vacunaDetalle!.refuerzos[0].proximaFecha = "2023-09-11";
        vacunaModel.vacunaDetalle!.refuerzos[1].proximaFecha = null;
      }
    }
  }*/
  validateDates(List<VacunaModel> vacunasModel){
    for(VacunaModel vacuna in vacunasModel){

      log("vacuna : ${vacuna.nombre} , dosis : ${vacuna.vacunaDetalle!.dosis.length} , refuerzo : ${vacuna.vacunaDetalle!.refuerzos.length}");

      // VACUNAS CON UNA SOLA DOSIS
      if(vacuna.vacunaDetalle!.dosis.length == 1 &&
          vacuna.vacunaDetalle!.refuerzos.isEmpty){

        if(vacuna.vacunaDetalle!.dosis.last.fecha != null){
          vacuna.vigenciaVacuna = VigenciaVacuna.active;
        }else{
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }
      }

      // VACUNAS CON MAS DE UNA DOSIS
      if(vacuna.vacunaDetalle!.dosis.length > 1 &&
          vacuna.vacunaDetalle!.refuerzos.isEmpty){

        int amountNull = 0;

        for(DosisModel dosisModel in vacuna.vacunaDetalle!.dosis){
          if(dosisModel.fecha == null){
            amountNull += 1;
          }
        }

        DosisModel lastDosis = vacuna.vacunaDetalle!.dosis.last;

        if( amountNull == vacuna.vacunaDetalle!.dosis.length ){
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }else{

          if( lastDosis.fecha != null ) {
            if(calculateDay(lastDosis.fecha!) <= 0){
              vacuna.vigenciaVacuna = stateVacuum(lastDosis.fecha!);
              vacuna.amountDay = calculateDay(lastDosis.fecha!);
            }else{
              vacuna.vigenciaVacuna = VigenciaVacuna.active;
            }

          } else {

            List<int> listIndex = [];
            int index = 0;

            for(DosisModel dosisModelTemp in vacuna.vacunaDetalle!.dosis){
              if(dosisModelTemp.fecha != null){
                listIndex.add(index);
              }
              index += 1;
            }

            // Verificar si tiene almenos dos items

            if(listIndex.length > 1){
              int indexSelected = listIndex.last;
              vacuna.vigenciaVacuna = stateVacuum(vacuna.vacunaDetalle!.dosis[indexSelected].fecha!);
              vacuna.amountDay = calculateDay(vacuna.vacunaDetalle!.dosis[indexSelected].fecha!);

            }else if(listIndex.length == 1){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.active;
            }else if(listIndex.isEmpty){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.empty;
            }

          }
        }


      }

      // VACUNAS CON MAS DE UNA DOSIS Y MAS DE UN REFUERZO
      if(vacuna.vacunaDetalle!.dosis.length > 1 &&
          vacuna.vacunaDetalle!.refuerzos.length > 1) {

        List<DosisModel> dosisGeneral = [];

        int amountNull = 0;

        for (DosisModel dosisModel in vacuna.vacunaDetalle!.dosis) {
          dosisGeneral.add(dosisModel);
          if(dosisModel.fecha == null){
            amountNull += 1;
          }
        }

        for (RefuerzoModel refuerzoModel in vacuna.vacunaDetalle!.refuerzos) {
          DosisModel dosisModel = DosisModel(
              refuerzoModel.nombre, refuerzoModel.nDosis,
              refuerzoModel.documento, refuerzoModel.estado,
              refuerzoModel.proximaFecha);
          dosisGeneral.add(dosisModel);
          if(dosisModel.fecha == null){
            amountNull += 1;
          }
        }
          
        // Si la cantidad de null es igual a la cantidad total
        if( amountNull == dosisGeneral.length ){
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }else{
          
          if(dosisGeneral.last.fecha != null){
            print('listadoDosis');
            print(dosisGeneral.last.nombre);
            log("esta es :  ${vacuna.nombre}");
            vacuna.vigenciaVacuna = stateVacuum(dosisGeneral.last.fecha!);
            vacuna.amountDay = calculateDay(dosisGeneral.last.fecha!);

          }else{

            List<int> listIndex = [];
            int index = 0;

            for(DosisModel dosisModelTemp in dosisGeneral){
              if(dosisModelTemp.fecha != null){
                listIndex.add(index);
              }
              index += 1;
            }

            // Verificar si tiene almenos dos items

            if(listIndex.length > 1){
              int indexSelected = listIndex.last;

              vacuna.vigenciaVacuna = stateVacuum(dosisGeneral[indexSelected].fecha!);
              vacuna.amountDay = calculateDay(dosisGeneral[indexSelected].fecha!);

            }else if(listIndex.length == 1){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.active;
            }else if(listIndex.isEmpty){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.empty;
            }
          }

        }


      }

      // VACUNAS SIN DOSIS Y MAS DE UN REFUERZO
      if(vacuna.vacunaDetalle!.dosis.isEmpty  &&
          vacuna.vacunaDetalle!.refuerzos.length > 1){

        int amountNull = 0;

        for(RefuerzoModel refuerzoModel in vacuna.vacunaDetalle!.refuerzos){
          if(refuerzoModel.proximaFecha == null){
            amountNull += 1;
          }
        }
        if(amountNull != vacuna.vacunaDetalle!.refuerzos.length ){

          RefuerzoModel refuerzoModel = vacuna.vacunaDetalle!.refuerzos[1];

          vacuna.vigenciaVacuna = stateVacuum(refuerzoModel.proximaFecha!);
          vacuna.amountDay = calculateDay(refuerzoModel.proximaFecha!);

        }else if (amountNull == 1){
          vacuna.vigenciaVacuna = VigenciaVacuna.active;

        }else if ( amountNull == 0 ){
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }
      }

    }
  }

  VigenciaVacuna stateVacuum(String fecha){
    VigenciaVacuna vigenciaVacuna = VigenciaVacuna.empty;
    DateTime now = DateTime.now();
    DateTime parseFecha = DateTime.parse(fecha);

    int amountDay = now.difference(parseFecha).inDays;

    log(" $now - $parseFecha : $amountDay");
    // VIGENTE
    if( amountDay > 0){
      vigenciaVacuna = VigenciaVacuna.noActive;
    }
    // POR VENCERSE
    if( -7 < amountDay && amountDay <= 0 ){
      vigenciaVacuna = VigenciaVacuna.toExpire;
    }
    // VENCIDO
    if( amountDay <= -7 ){
      vigenciaVacuna = VigenciaVacuna.active;
    }
    return vigenciaVacuna;
  }

  int calculateDay(String fecha){
    DateTime now = DateTime.now();
    DateTime parseFecha = DateTime.parse(fecha);

    int amountDay = now.difference(parseFecha).inDays;
    return amountDay;
  }
}
