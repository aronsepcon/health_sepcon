
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/carousel_data/manually_controller_slider.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';


class DocumentIdentityPage extends StatefulWidget {
  const DocumentIdentityPage({super.key});

  @override
  State<DocumentIdentityPage> createState() => _DocumentIdentityPageState();
}

class _DocumentIdentityPageState extends State<DocumentIdentityPage> {

  late File filePdf;

  final List<String> imgList = [
    'assets/document/document_frontal_0.png',
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: SafeArea(
          child: Padding(
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
                      GeneralWord.identityDocumentHome,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Image(image: AssetImage('assets/empty_document_identity.png'),height: 400,width: 400,),

                Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  onTap: (){
                    //_imgFromCamera();
                    routePDFViewer();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30),
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
            builder: (context) =>ManuallyControllerSlider(
              imgList: imgList,
              titleList: titleList,listFile: listfile,
              numberWidget: Constants.DOCUMENT_INIT,)));
  }

}
