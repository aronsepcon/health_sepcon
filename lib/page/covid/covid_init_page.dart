import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/covid/covid_carousel_page.dart';
import 'package:sepcon_salud/page/covid/covid_collect_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CovidInitPage extends StatefulWidget {
  const CovidInitPage({super.key});

  @override
  State<CovidInitPage> createState() => _CovidInitPageState();
}

class _CovidInitPageState extends State<CovidInitPage> {

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
                      'COVID',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const Image(image: AssetImage('assets/medicine.png'),height: 400,width: 400,),


                GestureDetector(
                  onTap: (){
                    widgetBottomSheet();
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
    bool result = await localStore.deleteKey(Constants.COVID);
    if(result){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
              CovidCarouselPage(imgList: imgList, titleList: titleList, titlePage: "COVID documentos")));

    }
  }
  widgetBottomSheet(){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 25,right: 25),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      findGalleryPhone();
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: GeneralColor.mainColor)

                      ),
                      child: Icon(Icons.picture_as_pdf_outlined,size: 50),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      routePDFViewer();
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: GeneralColor.mainColor)

                      ),
                      child: Icon(Icons.photo_camera,size: 50,),
                    ),
                  )
                ],
              )
            ),
          ),
        );
      },
      isScrollControlled:true,
    );
  }

  findGalleryPhone() async {
    LocalStore localStore = LocalStore();
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((pathR) => File(pathR!)).toList();
      log("result ${files.length}");

      List<String> tempList = await localStore.fetchPathsFileByTypeDocument(Constants.COVID);

      for(File tempFile in files){
        tempList.add(tempFile.path);
      }

      log("LIST ${tempList.length}");
      bool resultFiles = await localStore.saveFilePaths(Constants.COVID,tempList);

      if(resultFiles){
        Navigator.pushReplacement(
            context ,
            MaterialPageRoute(
                builder: (_) => CovidCollectPage()));
      }

    } else {
      // User canceled the picker
      log("result null");
    }
  }

}
