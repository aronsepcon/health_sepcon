
import 'dart:developer';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/page/covid/covid_carousel_page.dart';
import 'package:sepcon_salud/page/covid/covid_filter_page.dart';
import 'package:sepcon_salud/page/covid/covid_preview_pdf_page.dart';
import 'package:sepcon_salud/util/edge_detection/process_image.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CovidCollectPage extends StatefulWidget {
  const CovidCollectPage({super.key});

  @override
  State<CovidCollectPage> createState() => _CovidCollectPageState();
}

class _CovidCollectPageState extends State<CovidCollectPage> {

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
  late LocalStore localStore;
  late List<String> imgList;
  late List<String> titleList;

  @override
  void initState() {
    super.initState();
    initVariable();
    fetchFilePaths();
  }

  initVariable(){
    title = Constants.TITLE_COVID;
    keyDocument = Constants.KEY_COVID;
    nextTitlePage = Constants.TITLE_COVID;
    titleAddButton = 'Agregar una foto';
    titleCreatePdfButton = 'Crear PDF';
    files = [];
    loading = false;
    filePdf = File("");
    localStore = LocalStore();
    imgList = Constants.imgListCovid;
    titleList = Constants.titleListGeneral;
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
       // openEdgeDetectionCamara();
        widgetBottomSheet();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom:5),
        child: Container(
          padding: const EdgeInsets.only(top: 15,bottom: 15),
          //margin: const EdgeInsets.symmetric(horizontal: 15),
          //height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: GeneralColor.mainColor,
                  width: 2),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Center(
              child: Text(
                titleButton,
                style: TextStyle(
                    color: GeneralColor.mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ),
      ),
    );
  }

  generatePdfButton(String titleButton){
    return GestureDetector(
      onTap: (){
        if(loading){
          createPDFNew();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom:5),
        child: Container(
          padding: const EdgeInsets.only(top: 15,bottom: 15),
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
    );
  }

  List<Widget> generateListFile(){
    List<Widget> tempFiles = [];
    for(File file in files){
      Widget fileWidget = Container();
      if(file.path.contains("pdf")){
        fileWidget = SizedBox(height: 300,child: PdfContainer(
          urlPdf: file.path,isLocal : true,
          titlePDF: "",));
      }else{
        fileWidget = Image.file(
          file,
          height: 200,
          width: MediaQuery.of(context).size.width,
        );
      }

      tempFiles.add(fileWidget);
    }
    return tempFiles;
  }

  openEdgeDetectionCamara() async {
    imagePath = await ProcessImage.pathImage();
    if(imagePath.isNotEmpty){
      bool result = await ProcessImage.getImageFromCamera(imagePath);
      if(result){
        routeVacuumFilterPage();
      }
    }
  }

  routeVacuumFilterPage(){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
            CovidFilterPage(file: File(imagePath),titlePage:nextTitlePage,)));

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
      if(!file.path.contains(".pdf")){
        document.pages.add().graphics.drawImage(
            PdfBitmap(await _readImageData( file.path)),
            const Rect.fromLTWH(0, 0, 750, 500));
      }
    }

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
      String? mergePath = await mergePaths(file.path);
      if(mergePath!= null){
        routePDFViewer(mergePath);
      }
    }
  }

  Future<String?> mergePaths(String mergeFilePhoto) async {
    String? mergedPdfPath = "";
    List<String> filePdf = [];
    for(File file in files){
      if(file.path.contains(".pdf")){
        filePdf.add(file.path);
      }
    }
    filePdf.add(mergeFilePhoto);
    if(filePdf.length > 1){
      mergedPdfPath = await PdfManipulator().mergePDFs(
        params: PDFMergerParams(pdfsPaths: filePdf),
      );
    }else{
      mergedPdfPath = mergeFilePhoto;
    }
    return mergedPdfPath;
  }

  routePreviewPdf(){
    setState(() {
      loading = true;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CovidPreviewPdfPage(file: filePdf )));
  }

  loadWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [getLoadEffect()],
      ),
    );
  }


  galleryButtonWidget(String titleButton){
    return GestureDetector(
      onTap: () {
        findGalleryPhone();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: GeneralColor.mainColor),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo,
                    color: GeneralColor.mainColor,
                  ),
                  Text(
                    titleButton,
                    style: TextStyle(
                        color: GeneralColor.mainColor,
                        fontSize: 16),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  takePhotoWidget(String titleButton){
    return  GestureDetector(
      onTap: (){
        routeCarouselPage();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          //margin: const EdgeInsets.symmetric(horizontal: 15),
          //height: 50,
          decoration: BoxDecoration(
              color: GeneralColor.mainColor,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                  Text(
                    titleButton,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  widgetBottomSheet(){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: widthScreen,
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Column(
                  children: [
                    titleBottomWidget("Tenemos dos opciones para subir los archivos"),
                    spaceWidget(20),
                    galleryButtonWidget("Subir fotos o archivos pdf"),
                    takePhotoWidget("Tomar una foto")
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((pathR) => File(pathR!)).toList();

      List<String> tempList = await localStore.fetchPathsFileByTypeDocument(keyDocument);

      for(File tempFile in files){
        tempList.add(tempFile.path);
      }

      bool resultFiles = await localStore.saveFilePaths(keyDocument,tempList);

      if(resultFiles){
        setState(() {
          this.files.addAll(files);
        });
      }
      Navigator.of(context).pop();

    } else {
      log("result null");
    }
  }

  titleBottomWidget(String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: widthScreen! * 0.8,
          child: Text(
            title,
            style: const
            TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  routeCarouselPage() async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
            CovidCarouselPage(
                imgList: imgList,
                titleList: titleList, titlePage: title )));
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

  routePDFViewer(String path){
    File tempFile = File(path);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CovidPreviewPdfPage(file: tempFile )));
  }

}
