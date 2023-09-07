import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencv_brightness/edge_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/document_identidad/document_carousel_page.dart';
import 'package:sepcon_salud/page/document_identidad/document_collect_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/edge_detection/edge_detector.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class DocumentFirstPage extends StatefulWidget {
  final File file;
  final int numberPage;

  const DocumentFirstPage({super.key, required this.file,required this.numberPage });

  @override
  State<DocumentFirstPage> createState() => _DocumentFirstPageState();
}

class _DocumentFirstPageState extends State<DocumentFirstPage> {

  late bool loading = false;
  String newPhoto = "";

  late File normalFile;
  late File claroFile;
  late File magicFile;

  late String pathNormalFile;
  late String pathClaroFile;
  late String pathMagicFile;

  late String viewPhoto;
  late LocalStore localStore;

  @override
  void initState() {
    super.initState();
    initVariable();
    createFiles();
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
          child: loading ?
          Padding(
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
                      'Primera cara',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Image.file(
                  File(viewPhoto),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),


                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // normal
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          setState(() {
                            viewPhoto = pathNormalFile;
                          });
                        });
                      },
                      child:Column(
                        children: [
                          Image.file(
                            File(pathNormalFile),
                            height: 80,
                            width: 80,
                          ),
                          Text('Normal'),
                        ],
                      )
                    ),

                    // claro
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          viewPhoto = pathClaroFile;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            Image.file(
                              File(pathClaroFile),
                              height: 80,
                              width: 80,
                            ),
                            Text('Aclarar'),
                          ],
                        ),
                      ),
                    ),

                    // magico
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          viewPhoto = pathMagicFile;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            Image.file(
                              File(pathMagicFile),
                              height: 80,
                              width: 80,
                            ),
                            Text('Magico'),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),

                GestureDetector(
                  onTap: (){
                    routeDocumentCarouselPage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:30),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      //margin: const EdgeInsets.symmetric(horizontal: 15),
                      //height: 50,
                      decoration: BoxDecoration(
                          color: GeneralColor.mainColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text(
                            'Volver a tomar foto',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                    ),
                  ),
                ),


                GestureDetector(
                  onTap: (){
                    saveLocalStoragePaths();
                    },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:30),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      //margin: const EdgeInsets.symmetric(horizontal: 15),
                      //height: 50,
                      decoration: BoxDecoration(
                          color: GeneralColor.mainColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text(
                            'Siguiente',
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
          ) : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [getLoadEffect()],
            ),
          )
      ),
    );
  }

  initVariable(){
    localStore = LocalStore();
  }

  saveLocalStoragePaths() async {
    List<String> tempList = await localStore.fetchPathsFileByTypeDocument(Constants.DOCUMENT_IDENTIDAD);
    tempList.add(viewPhoto);
    bool result = await localStore.saveFilePaths(Constants.DOCUMENT_IDENTIDAD,tempList);
    if(result){
      routeDocumentCollectPage();
    }
  }

  routeDocumentCarouselPage(){
    Navigator.pushReplacement(
        context ,
        MaterialPageRoute(
            builder: (_) => DocumentCarouselPage(
                imgList: Constants.imgListDocumentFirst,
                titleList: Constants.titleListDocumentFirst,
                numberPage: Constants.DOCUMENT_FIRST)));
  }

  routeDocumentCollectPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentCollectPage(numberPage: widget.numberPage,)));
  }

  createFiles() async {
    Uint8List bytes = widget.file.readAsBytesSync();

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);

    pathNormalFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_normal.png';
    normalFile = File(pathNormalFile);
    await normalFile.writeAsBytes(bytes);

    pathClaroFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_claro.png';
    claroFile = File(pathClaroFile);
    await claroFile.writeAsBytes(bytes);

    pathMagicFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_magic.png';
    magicFile = File(pathMagicFile);
    await magicFile.writeAsBytes(bytes);

    getMagicColor();

  }

  Future getMagicColor() async {
    Offset topLeft = const Offset(0.0, 0.0);
    Offset topRight = const Offset(1.0, 0.0);
    Offset bottomLeft = const Offset(0.0, 1.0);
    Offset bottomRight = const Offset(1.0, 1.0);

    EdgeDetectionResult edgeDetectionResult = EdgeDetectionResult(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight);
    bool resultMagic = await EdgeDetector().processImage(pathMagicFile,edgeDetectionResult);

    bool resultClaro = await EdgeDetector().processImageLight(pathClaroFile, edgeDetectionResult);

    if (resultMagic == false && resultClaro == false) {
      return;
    }

    setState(() {
      imageCache.clearLiveImages();
      imageCache.clear();
      viewPhoto = pathMagicFile;
      loading = true;
    });
  }

}
