
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_carousel_page.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_preview_pdf_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/edge_detection/process_image.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
class PaseMedicoCollectPage extends StatefulWidget {
  final int numberPage;
  const PaseMedicoCollectPage({super.key,required this.numberPage});

  @override
  State<PaseMedicoCollectPage> createState() => _PaseMedicoCollectPageState();
}

class _PaseMedicoCollectPageState extends State<PaseMedicoCollectPage> {

  late List<String> filePaths;
  late List<File> files;
  late bool loading;
  late File filePdf;
  late String title;
  late int amountFiles;
  late String imagePath;
  late String nextTitlePage;
  late String keyDocument;
  late String titleAddButton;
  late String titleCreatePdfButton;
  late double? heightScreen;
  late double? widthScreen;
  late List<String> imgList;
  late List<String> titleList;

  @override
  void initState() {
    super.initState();
    initVariable();
    fetchFilePaths();
  }

  initVariable(){
    title = Constants.TITLE_PASE_MEDICO;
    keyDocument = Constants.KEY_PASE_MEDICO;
    nextTitlePage = Constants.TITLE_PASE_MEDICO;
    titleList =  Constants.titleListGeneral;
    imgList = Constants.imgListPaseMedicoSecond;
    titleAddButton = 'Tomar la parte posterior';
    titleCreatePdfButton = 'Crear PDF';
    files = [];
    loading = false;
    filePdf = File("");
  }

  appBarWidget(){
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  titleWidget(String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  amountPhotos(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${files.length} foto(s)',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  containerFiles(){
    return  Container(
      width: widthScreen! * 0.9,
      height: heightScreen! * 0.6,
      child: SingleChildScrollView(
        child: Column(
          children: generateListFile(),
        ),
      ),
    );
  }

  addPhotoButton(String titleButton){
    return  GestureDetector(
      onTap: (){
        openEdgeDetectionCamara();
      },
      child: widget.numberPage == 1 ? GestureDetector(
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
            child: Center(
                child: Text(
                  titleButton,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          ),
        ),
      ) : Container(),
    );
  }

  generatePdfButton(String titleButton){
    return GestureDetector(
      onTap: (){
        if(loading){
          createPDFNew();
        }
      },
      child:  widget.numberPage == 1 ? Container() : GestureDetector(
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
            child: Center(
                child: Text(
                  titleButton,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          ),
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
        width: widthScreen,
      );
      tempFiles.add(image);
    }
    return tempFiles;
  }

  openEdgeDetectionCamara() async {
    imagePath = await ProcessImage.pathImage();
    if(imagePath.isNotEmpty){
      bool result = await ProcessImage.getImageFromCamera(imagePath);
      if(result){
        routeDocumentCarouselPage();
      }
    }
  }



  fetchFilePaths() async {
    LocalStore localStore = LocalStore();
    List<String>? result = await localStore
        .fetchPathsFileByTypeDocument(keyDocument);
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
    setState(() {
      loading = false;
    });
    PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.landscape;

    for(File file in files){
      document.pages.add().graphics.drawImage(
          PdfBitmap(await _readImageData( file.path)),
          const Rect.fromLTWH(0, 0, 750, 500));
    }

    List<int> bytes = document.saveSync();
    document.dispose();
    saveAndLaunchFile(bytes);
  }

  Future<Uint8List> _readImageData(String name) async {////ES AQUI DONDE SE PUEDE REALIZAR LA COMPRESION
    File imageFile = File(name);
    var result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 40,
    );

    if (result != null) {
      return result;
    } else{
      return imageFile.readAsBytes();
    }

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
            builder: (context) => PaseMedicoPreviewPdfPage(file: filePdf)));
  }

  routeDocumentCarouselPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaseMedicoCarouselPage(
              imgList: imgList,
              titleList: titleList,
              numberPage : Constants.DOCUMENT_SECOND,)));
  }

  loadWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [getLoadEffect()],
      ),
    );
  }

  spaceWidget(double space){
    return SizedBox(
      height: space,
    );
  }

  expandedWidget(){
    return const Expanded(
      child: SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(),
      body: loading ? Padding(
        padding: const EdgeInsets.only(left: 25.0,right: 25.0),
        child: Column(
          children: [
            titleWidget(title),
            amountPhotos(),
            spaceWidget(20),
            containerFiles(),
            expandedWidget(),
            addPhotoButton(titleAddButton),
            generatePdfButton(titleCreatePdfButton),
          ],
        ),
      ) : loadWidget(),
    );
  }

}
