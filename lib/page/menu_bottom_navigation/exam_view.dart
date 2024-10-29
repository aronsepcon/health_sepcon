import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_carousel_page.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/pase_medico_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/custom_permission.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/share_widget.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {

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
  late String titleVigencia;
  late bool statuValidated;
  late bool statusVigencia;
  late String splitUrl;
  late String motivoEmo;
  late List<String> imgList;
  late List<String> titleList;
  late int numberPage;
  late DocumentVacunaModel? documentVacuumModel;
  late bool loading = false;
  late String mensajeEmo ;
  late String mensajeVigencia;

  @override
  void initState() {
    super.initState();
    initVariable();
    findUserAndDocumentAndCostosLocalStorage();
  }

  initVariable(){
   // documentVacuumModel = DocumentVacunaModel(null, null, null, null, null);
    title =  Constants.TITLE_EMO;
    downloadName = "EMO-${DateTime.now().millisecondsSinceEpoch}";
    localStore = LocalStore();
    titleDownloadButton = "Descargar";
    isDownloading = false;
    progress = 0;
    downloading = false;
    checkAllPermissions = CheckPermission();
    getPathFile = DirectoryPath();
    titleValidated = "Verificado ";
    noTitleValidated = "Pendiente de verificar";
    titleVigencia = "Vigencia hasta ";
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
    if(urlPdf.isEmpty){
      return Container();
    }else{
      return SizedBox( height: heightScreen! * 0.6,child:
      PdfContainer(
        urlPdf: urlPdf,
        isLocal : false,
        titlePDF: titlePdf(),));
    }

  }

  downloadButtonWidget(String titleButton){
    return GestureDetector(
      onTap: () {
        log("answer" + isDownloading.toString());
        downloadFile(downloadName);

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

  updateButtonWidget(String titleButton,String keyDocument){
    return  GestureDetector(
      onTap: (){
        routeCarouselPage(keyDocument);
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
          Text(titleValidated ,style: TextStyle(color: GeneralColor.greenColor),),
          Text(mensajeEmo ,style: TextStyle(color: GeneralColor.greenColor),),
        ],
      );
    }else{
      return Row(
        children: [
          const Icon(Icons.check_circle,color: Colors.amber,),
          Text(noTitleValidated,style: TextStyle(color: Colors.amber,),),
          Text(mensajeEmo  ,style: TextStyle(color: Colors.amber,),),

        ],
      );
    }
  }

  Widget statusVigenciaDate(){
    if (statusVigencia) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green,),
          Text(titleVigencia,style: TextStyle(color: GeneralColor.greenColor),),
          Text(mensajeVigencia,style: TextStyle(color: GeneralColor.greenColor),)
        ],
      );
    }else{
      return Row(
        children: [
          const Icon(Icons.dangerous_rounded, color: Colors.red,),
          Text(titleVigencia,style: TextStyle(color: Colors.red,),),
          Text(mensajeVigencia,style: TextStyle(color: Colors.red,),),
        ],
      );
    }
    
  }

  Widget motivoVigencia(){
    return Row(children: [
      Text("Motivo: "+ motivoEmo)
    ],);
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

  // REPLACE

  routeCarouselPage(String keyDocument) async {
    bool result = await localStore.deleteKey(keyDocument);
    if(result){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>PaseMedicoCarouselPage(
                imgList: imgList ,
                titleList: titleList,
                numberPage: numberPage,)));
    }
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(),
      body: SafeArea(
        child: Center(
          child: loading ? Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                titleWidget(title),
                spaceWidget(10),
                statusDocument(),
                spaceWidget(3),
                statusVigenciaDate(),
                spaceWidget(3),
                motivoVigencia(),
                spaceWidget(10),
                pdfContainerWidget(urlPdfContainer),
                expandedWidget(),
                downloadButtonWidget(titleDownloadButton),
              ],
            ),
          ) : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [getLoadEffect()],
            ),
          ),
        ),
      ),
    );
  }

  findUserAndDocumentAndCostosLocalStorage() async {
    documentVacuumModel = await localStore.fetchVacunaGeneral();
    print(documentVacuumModel);
    if(documentVacuumModel != null ){
      setState(() {
        loading = true;
        urlPdfContainer = documentVacuumModel!.emoModel!.adjunto!;
        log("url : " + urlPdfContainer);
        statuValidated =documentVacuumModel!.emoModel!.validated!;
        splitUrl = documentVacuumModel!.emoModel!.adjunto!;
        mensajeEmo =  documentVacuumModel!.emoModel!.mensaje!;
        mensajeVigencia = documentVacuumModel!.emoModel!.vigencia!;
        statusVigencia = documentVacuumModel!.emoModel!.validate_vigencia!;
        motivoEmo = documentVacuumModel!.emoModel!.motivo_vigencia!;
      });
    }else{
      print('errror pdf');
    }
  }
}


