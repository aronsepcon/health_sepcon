import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/vacuum/carousel_vacuum.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class InitVacuum extends StatefulWidget {
  const InitVacuum({super.key});

  @override
  State<InitVacuum> createState() => _InitVacuumState();
}

class _InitVacuumState extends State<InitVacuum> {

  final List<String> imgList = [
    'assets/vaccine/vacuna_1.png',
    'assets/document/document_frontal_4.png',
  ];
  final List<String> titleList = [
    '1. Posición correcta del documento',
    '2. Empezar a tomar la foto',
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
                      'Vacunas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const Image(image: AssetImage('assets/medicine.png'),height: 400,width: 400,),


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

  routePDFViewer() async {
    LocalStore localStore = LocalStore();
    bool result = await localStore.deleteKey(Constants.DOCUMENT_VACUUM);
    if(result){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>CarouselVacuum(
                imgList: imgList,
                titleList: titleList,titlePage: "Certificado de vacunas",)));
    }
  }

}
