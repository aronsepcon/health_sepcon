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

class DocumentFilterPage extends StatefulWidget {
  final File file;
  final int numberPage;

  const DocumentFilterPage({super.key, required this.file,required this.numberPage });

  @override
  State<DocumentFilterPage> createState() => _DocumentFilterPageState();
}

class _DocumentFilterPageState extends State<DocumentFilterPage> {

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
  late double? heightScreen;
  late double? widthScreen;


  @override
  void initState() {
    super.initState();
    initVariable();
    createFiles();
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: loading ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: loading ? Colors.black: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                color: loading ? Colors.white : Colors.black,),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.numberPage == 1 ? "Frente" : "Posterior",
                      style: const TextStyle(fontSize: 24,
                          fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                Image.file(
                  File(viewPhoto),
                  height: heightScreen! * 0.3,
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
                      child:Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Stack(
                          children: [
                            Image.file(
                              File(pathNormalFile),
                              height: 80,
                              width: widthScreen! * 0.28,
                            ),
                            Container(
                              width: widthScreen! * 0.28,
                              color: Colors.black38,
                              height: 20,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Normal',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,
                                  ),),
                              ),
                            )
                          ],
                        ),
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
                        padding: const EdgeInsets.only(left: 5),
                        child: Stack(
                          children: [
                            Image.file(
                              File(pathClaroFile),
                              height: 80,
                              width: widthScreen! * 0.28,
                            ),
                            Container(
                              width: widthScreen! * 0.28,
                              color: Colors.black38,
                              height: 20,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Aclarar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,
                                  ),),
                              ),
                            )
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
                        padding: const EdgeInsets.only(left: 5),
                        child: Stack(
                          children: [
                            Image.file(
                              File(pathMagicFile),
                              width: widthScreen! * 0.28,
                            ),
                            Container(
                              width: widthScreen! * 0.28,
                              color: Colors.black38,
                              height: 20,
                              child: const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Mágico',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,
                                  ),),
                              ),
                            )
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
                  onTap: () {
                    routeDocumentCarouselPage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: GeneralColor.mainColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                color: GeneralColor.mainColor,
                              ),
                              Text(
                                'Reintentar',
                                style: TextStyle(
                                    color: GeneralColor.mainColor,
                                    fontSize: 16),
                              ),
                            ],
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
                            'Confirmar',
                            style: TextStyle(
                                color: Colors.white,
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
    List<String> tempList = await localStore.fetchPathsFileByTypeDocument(Constants.KEY_DOCUMENTO_IDENTIDAD);
    tempList.add(viewPhoto);
    bool result = await localStore.saveFilePaths(Constants.KEY_DOCUMENTO_IDENTIDAD,tempList);
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
