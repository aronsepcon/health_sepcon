import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:sepcon_salud/page/covid/carousel_covid_page.dart';
import 'package:sepcon_salud/page/covid/collect_photo_covid_page.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/custom_permission.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CovidHomePage extends StatefulWidget {
  final String urlPdf;
  const CovidHomePage({super.key,required this.urlPdf});

  @override
  State<CovidHomePage> createState() => _CovidHomePageState();
}

class _CovidHomePageState extends State<CovidHomePage> {

  final List<String> imgList = [
    'assets/document/document_frontal_0.png',
    'assets/document/document_frontal_4.png',
  ];
  final List<String> titleList = [
    '1. Posición correcta del documento',
    '2. Empezar a tomar la foto',
  ];

  bool isPermission = false;
  var checkAllPermissions = CheckPermission();
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();
  late LocalStore localStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    localStore = LocalStore();
    setState(() {
      fileName = Path.basename(widget.urlPdf);
    });

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
                    'Vista previa',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(height: 450,child: PdfContainer(
                urlPdf: widget.urlPdf,isLocal : false,
                titlePDF: "COVID",)),
              const Expanded(
                child: SizedBox(),
              ),

              GestureDetector(
                onTap: () {
                  //DateTime now = DateTime.now();
                  var fileName = "DNI-${DateTime.now().millisecondsSinceEpoch}";
                  downloadFile(fileName);
                },
                child:Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    //margin: const EdgeInsets.symmetric(horizontal: 15),
                    //height: 50,
                    decoration: BoxDecoration(
                        color: GeneralColor.mainColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child:   dowloading
                            ? Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 3,
                              backgroundColor: Colors.white,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  GeneralColor.mainColor),
                            ),
                            Text(
                              "${(progress * 100).toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 12,color: Colors.white),
                            )
                          ],
                        )
                            : Text(
                          'Descargar',
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
                  widgetBottomSheet();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15,bottom: 15),
                    //margin: const EdgeInsets.symmetric(horizontal: 15),
                    //height: 50,
                    decoration: BoxDecoration(
                        color: GeneralColor.mainColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text(
                          'Actualizar documento',
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
        ),
      ),
    );
  }

  routePDFViewer(){
    List<File> listfile = [];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>CarouselCovidPage(
              titlePage: "COVID",
              imgList: imgList,
              titleList: titleList)));
  }

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  downloadFile(String name){
    print(name.replaceAll(" ", ""));
    FileDownloader.downloadFile(
        url: widget.urlPdf,
        name: name,
        onProgress: (String? fileName, double progressInput) {
          setState(() {
            dowloading = true;
            progress = progressInput;
          });
        },
        onDownloadCompleted: (String path) {
          var splitMessage = path.split("/");
          var message = splitMessage[splitMessage.length-1];
          setState(() {
            dowloading = false;
            widgetDirectoryDialog(message);
          });
          print('FILE DOWNLOADED TO PATH: $path');
        },
        onDownloadError: (String error) {
          print('DOWNLOAD ERROR: $error');
        });

  }

  widgetDirectoryDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text(
                  "Verificar documento en la carpeta Descargados",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  openfile(String path) {
    OpenFile.open(path);
    print("fff $path");
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
                        await localStore.deleteKey(Constants.COVID);
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
                        routePDFViewer();
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
  findGalleryPhone() async {

    localStore.deleteKey(Constants.COVID);

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
}


