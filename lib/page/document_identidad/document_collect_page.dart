
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/document_identidad/document_carousel_page.dart';
import 'package:sepcon_salud/page/document_identidad/document_preview_pdf_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentCollectPage extends StatefulWidget {
  final int numberPage;
  const DocumentCollectPage({super.key,required this.numberPage});

  @override
  State<DocumentCollectPage> createState() => _DocumentCollectPageState();
}

class _DocumentCollectPageState extends State<DocumentCollectPage> {

  late List<String> filePaths;
  late List<File> files = [];
  bool loading = false;
  File filePdf = File("");
  late double? heightScreen;
  late double? widthScreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFilePaths();
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white ,
      appBar: AppBar(
        backgroundColor:  Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
      ),
      body: loading ? Padding(
        padding: const EdgeInsets.only(left: 25.0,right: 25.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Documento de identidad',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${files.length} foto(s)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width:MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: generateListFile(),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),


            widget.numberPage == 1 ? GestureDetector(
              onTap: (){
                routeDocumentCarouselPage();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom:15),
                child: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  //margin: const EdgeInsets.symmetric(horizontal: 15),
                  //height: 50,
                  decoration: BoxDecoration(
                      color: GeneralColor.mainColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text(
                        'Tomar la reversa',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
              ),
            ) : Container(),
            widget.numberPage == 1 ? Container() : GestureDetector(
              onTap: (){
                createPDFNew();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom:15),
                child: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  //margin: const EdgeInsets.symmetric(horizontal: 15),
                  //height: 50,
                  decoration: BoxDecoration(
                      color: GeneralColor.mainColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            'Exportar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      )),
                ),
              ),
            ) ,
          ],
        ),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getLoadEffect()],
        ),
      ),
    );
  }

  List<Widget> generateListFile(){
    List<Widget> tempFiles = [];
    for(File file in files){
      Widget image = Image.file(
        file,
        height: 200,
        width: MediaQuery.of(context).size.width,
      );
      tempFiles.add(image);
    }
    return tempFiles;
  }



  fetchFilePaths() async {
    LocalStore localStore = LocalStore();
    List<String>? result = await localStore
        .fetchPathsFileByTypeDocument(Constants.KEY_DOCUMENTO_IDENTIDAD);

    if(result != null){
      setState(() {
        for (var element in result) {
          File file = File(element);
          files.add(file);
        }

        loading = true;
      });
    }
  }

  createPDFNew() async {
    PdfDocument document = PdfDocument();
    //Change the page orientation to landscape
    final page = document.pages.add();

    page.graphics.drawImage(
        PdfBitmap(await _readImageData( files[0].path)),
        const Rect.fromLTWH(0, 0, 500, 350));

    page.graphics.drawImage(
        PdfBitmap(await _readImageData( files[1].path)),
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
    File file = await filePdf.writeAsBytes(bytes, flush: true);
    if(file.existsSync()){
      routeDocumentPreviewPdfPage();
    }
  }

  routeDocumentPreviewPdfPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentPreviewPdfPage(file: filePdf)));
  }

  routeDocumentCarouselPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>DocumentCarouselPage(
              imgList: Constants.imgListDocumentSecond,
              titleList: Constants.titleListDocumentSecond,
              numberPage : Constants.DOCUMENT_SECOND,)));
  }

}
