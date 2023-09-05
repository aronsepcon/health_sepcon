import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencv_brightness/edge_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/edge_detection/edge_detector.dart';
import 'package:sepcon_salud/page/document_identidad/pdf_viewer_page.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentSecondPage extends StatefulWidget {
  final List<File> file;

  const DocumentSecondPage({super.key,required this.file});

  @override
  State<DocumentSecondPage> createState() => _DocumentSecondPageState();
}

class _DocumentSecondPageState extends State<DocumentSecondPage> {
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
    super.initState();
    //createPDFNew(widget.file);
    filePdf = File('');
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
          child: loading ? Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Segunda cara',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                Image.file(
                  File(widget.file[0].path),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                Image.file(
                  File(viewPhoto),
                  height: MediaQuery.of(context).size.height * 0.25,
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
                    //routePDFViewer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:5),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      //margin: const EdgeInsets.symmetric(horizontal: 15),
                      //height: 50,
                      decoration: BoxDecoration(
                          color: GeneralColor.mainColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text(
                            'volver a tomar foto',
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
                    widget.file[1] = File(viewPhoto);
                    createPDFNew(widget.file);
                    //routePDFViewer();
                    // imgFromCamera(context);
                    // routeSecondPage(context);
                    //getData();
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
                            'Generar PDF',
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
          )),
    );
  }

  createPDFNew(List<File> listFile) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawImage(
        PdfBitmap(await _readImageData( listFile[0].path)),
        const Rect.fromLTWH(0, 0, 500, 350));

    page.graphics.drawImage(
        PdfBitmap(await _readImageData( listFile[1].path)),
        const Rect.fromLTWH(0, 360, 500, 350));


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
    File tempFile =await filePdf.writeAsBytes(bytes, flush: true);

    if(tempFile.existsSync()){
      routePDFViewer(filePdf);
    }
  }


  routePDFViewer(File filePDF){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFViewerPage(file: filePDF )));
  }

  createFiles() async {
    Uint8List bytes = widget.file[1].readAsBytesSync();

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
