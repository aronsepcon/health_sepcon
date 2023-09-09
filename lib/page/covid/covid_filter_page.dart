import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:opencv_brightness/edge_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/covid/covid_collect_page.dart';
import 'package:sepcon_salud/page/vacuum/pdf_viewer_vacuum.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/edge_detection/edge_detector.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CovidFilterPage extends StatefulWidget {
  final File file;
  final String titlePage;

  const CovidFilterPage({super.key,required this.file,required this.titlePage});

  @override
  State<CovidFilterPage> createState() => _CovidFilterPageState();
}

class _CovidFilterPageState extends State<CovidFilterPage> {

  late File _image;
  List<File> listFile = [];
  late File filePdf;

  late bool loading = false;
  String newPhoto = "";

  late File normalFile;
  late File claroFile;
  late File magicFile;

  late String pathNormalFile;
  late String pathClaroFile;
  late String pathMagicFile;

  late String viewPhoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //listFile = widget.file;
    _image = File("");
    filePdf = File("");
    //createPDF(listFile);
    createPDFNew();
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
          child: loading? Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.titlePage,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

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


                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: () async {
                    //print(filePdf.path);
                    //routePDFViewer();
                    List<File> listFile = [];
                    listFile.add(File(viewPhoto));


                    LocalStore localStore = LocalStore();
                    List<String> tempList = await localStore.fetchPathsFileByTypeDocument(Constants.COVID);

                    tempList.add(viewPhoto);
                    log("LIST ${tempList.length}");
                    bool result = await localStore.saveFilePaths(Constants.COVID,tempList);

                    if(result){
                      Navigator.pushReplacement(
                          context ,
                          MaterialPageRoute(
                              builder: (_) => CovidCollectPage()));
                    }


                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
          )) ,
    );
  }

  createPDFNew() async {
    PdfDocument document = PdfDocument();
    //final page = document.pages.add();

    //Set the page size
    //document.pageSettings.size = PdfPageSize.a4;

    //Change the page orientation to landscape
    document.pageSettings.orientation = PdfPageOrientation.landscape;

    document.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData( listFile[0].path)),
        const Rect.fromLTWH(0, 0, 750, 500));

    List<int> bytes = document.saveSync();
    document.dispose();
    saveAndLaunchFile(bytes);
  }

  Future<Uint8List> _readImageData(String name) async {
    File imageFile = File(name);
    return imageFile.readAsBytes();

  }

  Future<void> saveAndLaunchFile(List<int> bytes) async {
    DateTime now = DateTime.now();
    final output = await getTemporaryDirectory();
    filePdf = File("${output.path}/example${now.toString().trim()}.pdf");
    await filePdf.writeAsBytes(bytes, flush: true);
  }


  routePDFViewer(){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfViewerVacuum(file: filePdf )));
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
