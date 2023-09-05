import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/carousel_data/manually_controller_slider.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/page/vacuum/certificado_vacuna.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPDFFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [

                  // HEADER
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back_ios),
                      ],
                    ),
                  ),
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
                        "Tipos",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Column(
                    children: widgetListTipos()
                  )

                ],
              ),
            ),
          )),
    );
  }

  List<Widget> widgetListTipos(){
    List<Widget> listTipos = [];

    for(String tipo in list){
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
                  widgetBottomSheet(tipo);
                },
                leading:  const Icon(Icons.check_circle,color: GeneralColor.greenColor,),
                title: Text(tipo),
                trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
              )
          ),

        ],
      );
      listTipos.add(widget);
    }

    return listTipos;
  }

  widgetBottomSheet(String title){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
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
                      title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Dosis 1 : ',style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('2022-07-12'),
                    ],
                  )
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    routePDFViewer();
                  },
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
              ],
            ),
          ),
        );
      },
    );
  }

  routePDFViewer(){
    List<File> listfile = [];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>ManuallyControllerSlider(imgList: imgList, titleList: titleList,listFile: listfile,numberWidget: 3,)));
  }

  certificadoVacuna(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CertificadoVacuna(path: path,)));
  }

  getPDFFile() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    path = prefs.getString('PDF_VACUNA')!;
    log(" PATH $path");
  }
}
