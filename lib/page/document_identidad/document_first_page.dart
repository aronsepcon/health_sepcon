import 'dart:developer';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_brightness/edge_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/edge_detection/edge_detector.dart';
import 'package:sepcon_salud/page/carousel_data/manually_controller_slider.dart';
import 'package:sepcon_salud/util/general_color.dart';

class DocumentFirstPage extends StatefulWidget {
  final List<File> file;

  const DocumentFirstPage({super.key, required this.file});

  @override
  State<DocumentFirstPage> createState() => _DocumentFirstPageState();
}

class _DocumentFirstPageState extends State<DocumentFirstPage> {

  late String pathPhoto;
  String newPhoto = "";
  List<File> listFile = [];

  final List<String> imgList = [
    'assets/document/document_reverso_0.png',
    'assets/document/document_reverso_2.jpeg',
    'assets/document/document_reverso_3.jpeg',
    'assets/document/document_reverso_1.png',
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
  void initState() {
    // TODO: implement initState
    super.initState();
    listFile = widget.file;
    pathPhoto = widget.file[0].path;

  }

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
                      'Primera cara',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                Image.file(
                  File(pathPhoto),
                  height: 200,
                  width: 200,
                ),

                (newPhoto.isNotEmpty) ?  Image.file(
                  File(pathPhoto),
                  height: 200,
                  width: 200,
                ) : Text('load'),

                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                   // imgFromCamera(context);
                   // routeSecondPage(context);
                    getData();
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
                          'Filtro uno',
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


  routeSecondPage(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>ManuallyControllerSlider(imgList: imgList, titleList: titleList,listFile: listFile,numberWidget: 2,)));
  }

  Future getData() async {
    Offset topLeft = const Offset(0.0, 0.0);
    Offset topRight = const Offset(1.0, 0.0);
    Offset bottomLeft = const Offset(0.0, 1.0);
    Offset bottomRight = const Offset(1.0, 1.0);

    EdgeDetectionResult edgeDetectionResult = EdgeDetectionResult(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight);
    bool result = await EdgeDetector().processImage(pathPhoto,edgeDetectionResult);

    if (result == false) {
      log("FALSEEEEEEEEE");
      return;
    }


    setState(() {
      log("TRUEEEEEEEEEEEE");
      imageCache.clearLiveImages();
      imageCache.clear();
      newPhoto = pathPhoto;
    });
  }
}
