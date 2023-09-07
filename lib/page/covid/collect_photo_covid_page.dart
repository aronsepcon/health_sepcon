
import 'dart:developer';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/page/covid/pdf_viewer_covid.dart';
import 'package:sepcon_salud/page/covid/preview_covid_page.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CollectPhotoCovidPage extends StatefulWidget {
  const CollectPhotoCovidPage({super.key});

  @override
  State<CollectPhotoCovidPage> createState() => _CollectPhotoCovidPageState();
}

class _CollectPhotoCovidPageState extends State<CollectPhotoCovidPage> {

  late List<String> filePaths;
  late List<File> files = [];
  bool loading = false;
  File filePdf = File("");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFilePaths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: loading ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certificado de vacunas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${files.length} foto(s)',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width:MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.55,
              child: SingleChildScrollView(
                child: Column(
                  children: generateListFile(),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),


            GestureDetector(
              onTap: (){
                widgetBottomSheet();
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
                        'Agregar +',
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
                createPDFNew();
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
                        'Crear PDF',
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

  Future<void> getImageFromCamera(BuildContext buildContext) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    //String imagePath = join((await getApplicationSupportDirectory()).path,
    //    "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String  imagePath  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.png';


    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Enfocar el documento', // use custom localizations for android
        androidCropTitle: 'Verificar',
        androidCropBlackWhiteTitle: 'Blanco',
        androidCropReset: 'Reestablecer',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreviewCovidPage(file: File(imagePath),titlePage:"Evidencia de vacunas",)));
    });

  }

  fetchFilePaths() async {
    LocalStore localStore = LocalStore();
    List<String>? result = await localStore
        .fetchPathsFileByTypeDocument(Constants.COVID);

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
    //final page = document.pages.add();

    //Set the page size
    //document.pageSettings.size = PdfPageSize.a4;

    //Change the page orientation to landscape
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
      routePDFViewer();
    }
  }

  routePDFViewer(){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfViewerCovid(file: filePdf )));
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
                builder: (_) => CollectPhotoCovidPage()));
      }

    } else {
      // User canceled the picker
      log("result null");
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
                        getImageFromCamera(context);
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


}
