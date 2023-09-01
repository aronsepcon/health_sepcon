import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/carousel_data/manually_controller_slider.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';

class InitPaseMedicoPage extends StatefulWidget {
  const InitPaseMedicoPage({super.key});

  @override
  State<InitPaseMedicoPage> createState() => _InitPaseMedicoPageState();
}

class _InitPaseMedicoPageState extends State<InitPaseMedicoPage> {

  late File filePdf;

  final List<String> imgList = [
    'assets/pasemedico/pase_medico_frontal_1.png',
    'assets/pasemedico/pase_medico_frontal_2.PNG',
    'assets/pasemedico/pase_medico_frontal_2.PNG',
    'assets/pasemedico/pase_medico_frontal_2.PNG',
    'assets/document/document_frontal_4.png',
  ];
  final List<String> titleList = [
    '1. Posición correcta del documento',
    '2. Tomar foto',
    '3. Verificar foto',
    '4. Guardar foto',
    '5. Empezar a tomar la foto',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
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
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pase medico',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const Image(image: AssetImage('assets/pasemedico/pase_medico.png'),height: 400,width: 400,),

                GestureDetector(
                  onTap: (){
                    //_imgFromCamera();
                    routePDFViewer();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 15,bottom: 15),
                    //margin: const EdgeInsets.symmetric(horizontal: 15),
                    //height: 50,
                    decoration: BoxDecoration(
                        color: GeneralColor.mainColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text(
                          'Iniciar',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                ),


              ],
            ),
          )),
    );
  }

  routePDFViewer(){
    List<File> listfile = [];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>ManuallyControllerSlider(imgList: imgList, titleList: titleList,listFile: listfile,numberWidget: 4,)));
  }

}
