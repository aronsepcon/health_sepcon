import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:sepcon_salud/page/covid/covid_carousel_page.dart';
import 'package:sepcon_salud/page/covid/covid_collect_page.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/util/share_widget.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/custom_permission.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CovidHomePage extends StatefulWidget {
  final VacunaModel covidModel;
  const CovidHomePage({super.key,required this.covidModel});

  @override
  State<CovidHomePage> createState() => _CovidHomePageState();
}

class _CovidHomePageState extends State<CovidHomePage> {


  late CheckPermission checkAllPermissions;
  late DirectoryPath getPathFile;
  late bool downloading;
  late double progress;
  late String downloadName ;
  late CancelToken cancelToken;
  late double? heightScreen;
  late double? widthScreen;
  late bool isDownloading;

  late String title;
  late String urlPdfContainer;
  late LocalStore localStore;
  late String keyDocument;
  late String titleDownloadButton;
  late String titleUpdateButton;
  late String titleValidated;
  late String noTitleValidated;
  late bool statuValidated;
  late String splitUrl;
  late List<String> imgList;
  late List<String> titleList;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  initVariable(){
    title =  Constants.TITLE_COVID;
    urlPdfContainer = widget.covidModel.adjunto!;
    keyDocument = Constants.KEY_COVID;
    imgList = Constants.imgListVacuum;
    titleList = Constants.titleListVacuum;
    downloadName = "COVID19-${DateTime.now().millisecondsSinceEpoch}";

    localStore = LocalStore();
    titleDownloadButton = "Descargar";
    titleUpdateButton = "Actualizar";
    isDownloading = false;
    progress = 0;
    downloading = false;
    checkAllPermissions = CheckPermission();
    getPathFile = DirectoryPath();
    titleValidated = "Verificado";
    noTitleValidated = "Pendiente de verificar";
    statuValidated = widget.covidModel.validated!;
    splitUrl = widget.covidModel.adjunto!;
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

  pdfContainerWidget(String urlPdf){
    return SizedBox( height: heightScreen! * 0.6,child:
    PdfContainer(
      urlPdf: urlPdf,
      isLocal : false,
      titlePDF: titlePdf(),));
  }

  downloadButtonWidget(String titleButton){
    return GestureDetector(
      onTap: () {
        if(!isDownloading){
          downloadFile(downloadName);
          isDownloading = true;
        }
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
              child: downloading
                  ? Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: GeneralColor.mainColorTransparent,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                        GeneralColor.mainColor),
                  ),
                  Text("${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 12, color:  GeneralColor.mainColor,),
                  )
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
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

  updateButtonWidget(String titleButton){
    return  GestureDetector(
      onTap: (){
        widgetBottomSheet();
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
                    Icons.refresh,
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

  Widget statusDocument(){
    if(statuValidated){
      return Row(
        children: [
          const Icon(Icons.check_circle,color: GeneralColor.greenColor,),
          Text(titleValidated ,style: TextStyle(color: GeneralColor.greenColor),)
        ],
      );
    }else{
      return Row(
        children: [
          const Icon(Icons.check_circle,color: Colors.amber,),
          Text(noTitleValidated,style: TextStyle(color: Colors.amber,),)
        ],
      );
    }
  }

  String titlePdf(){
    List<String> splitUrl = this.splitUrl.split("/");
    return splitUrl.last;
  }

  downloadFile(String name) async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      FileDownloader.downloadFile(
          url: urlPdfContainer,
          name: name,
          onProgress: (String? fileName, double progressInput) {
            setState(() {
              downloading = true;
              progress = progressInput / 100.0;
            });
          },
          onDownloadCompleted: (String path) {
            var splitMessage = path.split("/");
            var message = splitMessage[splitMessage.length-1];
            setState(() {
              downloading = false;
              isDownloading = false;
              widgetDirectoryDialog(message,context,heightScreen!);
            });
          },
          onDownloadError: (String error) {
          });
    }
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
        routeCollectPage();
      }

    } else {
      log("result null");
    }
  }

  routeCollectPage() async {
    Navigator.pushReplacement(
        context ,
        MaterialPageRoute(
            builder: (_) => const CovidCollectPage()));
  }

  routeCarouselPage() async {
    bool result = await localStore.deleteKey(keyDocument);
    if(result){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
              CovidCarouselPage(
                  imgList: imgList,
                  titleList: titleList, titlePage: title )));

    }
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
  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              titleWidget(title),
              spaceWidget(10),
              statusDocument(),
              spaceWidget(10),
              pdfContainerWidget(urlPdfContainer),
              expandedWidget(),
              downloadButtonWidget(titleDownloadButton),
              updateButtonWidget(titleUpdateButton),
            ],
          ),
        ),
      ),
    );
  }

}


