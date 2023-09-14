import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:sepcon_salud/page/vacuum/vacuum_carousel_page.dart';
import 'package:sepcon_salud/resource/model/vacuna_general_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/custom_permission.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/share_widget.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';

class VacuumCertificadoPage extends StatefulWidget {
  final VacunaGeneralModel vacunaGeneralModel;
  const VacuumCertificadoPage({super.key,required this.vacunaGeneralModel});

  @override
  State<VacuumCertificadoPage> createState() => _VacuumCertificadoPageState();
}

class _VacuumCertificadoPageState extends State<VacuumCertificadoPage> {

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
  late String NOMENCLATURA_VACUNA_INIT;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  initVariable(){
    title =  Constants.TITLE_CERTIFICADO_VACUNA;
    urlPdfContainer = widget.vacunaGeneralModel.documentGeneral!;
    downloadName = "TV-${DateTime.now().millisecondsSinceEpoch}";
    localStore = LocalStore();
    keyDocument = Constants.KEY_CERTIFICADO_VACUNA;
    titleDownloadButton = "Descargar";
    titleUpdateButton = "Actualizar";
    isDownloading = false;
    progress = 0;
    downloading = false;
    checkAllPermissions = CheckPermission();
    getPathFile = DirectoryPath();
    titleValidated = "Verificado";
    noTitleValidated = "Pendiente de verificar";
    NOMENCLATURA_VACUNA_INIT = "TV";
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
    if(widget.vacunaGeneralModel.validated!){
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
    List<String> splitUrl = widget.vacunaGeneralModel.tiposVacunas![2].adjunto!.split("/");
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
              builder: (context) => VacuumCarouselPage(
                imgList: Constants.imgListVacuum,
                titleList: Constants.titleListGeneral,
                titlePage: Constants.TITLE_CERTIFICADO_VACUNA,
                  nomenclatura: NOMENCLATURA_VACUNA_INIT
              )));
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
              updateButtonWidget(titleUpdateButton,keyDocument),
            ],
          ),
        ),
      ),
    );
  }
}
