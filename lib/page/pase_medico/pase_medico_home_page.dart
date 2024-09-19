import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_carousel_page.dart';
import 'package:sepcon_salud/resource/model/pase_medico_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/custom_permission.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/share_widget.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';

class PaseMedicoHomePage extends StatefulWidget {
  final PaseMedicoModel paseMedicoModel;
  const PaseMedicoHomePage({super.key,required this.paseMedicoModel});

  @override
  State<PaseMedicoHomePage> createState() => _PaseMedicoHomePageState();
}

class _PaseMedicoHomePageState extends State<PaseMedicoHomePage> {

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
  late String titleVencido;
  late String titleRechazado;
  late String estado;
  late bool statuValidated;
  late String splitUrl;
  late List<String> imgList;
  late List<String> titleList;
  late int numberPage;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  initVariable(){
    title =  Constants.TITLE_PASE_MEDICO;
    urlPdfContainer = widget.paseMedicoModel.adjunto!;
    keyDocument = Constants.KEY_PASE_MEDICO;
    imgList = Constants.imgListPaseMedicoFirst;
    titleList = Constants.titleListGeneral;
    numberPage = Constants.PASE_MEDICO_FIRST_PAGE;
    downloadName = "PM-${DateTime.now().millisecondsSinceEpoch}";

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
    titleRechazado = "Se ha rechazado el pase medico, reenviar";
    titleVencido = "Se ha vencido el pase medico";
    statuValidated = widget.paseMedicoModel.validated!;
    estado = widget.paseMedicoModel.estado!;
    splitUrl = widget.paseMedicoModel.adjunto!;
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
    return SizedBox( height: heightScreen! * 0.5,child:
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
     print("que pasoooo");
      print(estado);
    if(statuValidated){
     
      if (estado == '1') {
        return Row(
          children: [
            const Icon(Icons.check_circle,color: GeneralColor.greenColor,),
            Text(titleValidated ,style: TextStyle(color: GeneralColor.greenColor),),
          ],
        );
      } else if (estado == '2') {
        return Row(
        children: [
            const Icon(Icons.dangerous_rounded,color: Colors.red,),
            Text(titleRechazado ,style: TextStyle(color: Color.fromARGB(255, 151, 34, 30)),),
          ],
        );
      } else if (estado == "3"){
        return Row(
          children: [
            const Icon(Icons.dangerous_rounded,color: Color.fromARGB(255, 217, 41, 41),),
            Text(titleVencido ,style: TextStyle(color: Color.fromARGB(255, 151, 34, 30)),),],
        );
      } else {
        return Row(
          children: [
            const Icon(Icons.check_circle,color: Colors.amber,),
            Text(noTitleValidated,style: TextStyle(color: Colors.orange,),),
          ],
        );
      }
      
    }else{
      return Row(
        children: [
          const Icon(Icons.check_circle,color: Colors.amber,),
          Text(noTitleValidated,style: TextStyle(color: Colors.amber,),),
        ],
      );
    }
  }

  Widget messagePaseMedico(){
    return Column(
      children: [
        Text("Vigencia : "+widget.paseMedicoModel.vigencia! ),
        Text("Motivo : "+widget.paseMedicoModel.motivo! ),
        Text("Mensaje : "+widget.paseMedicoModel.mensaje! ),
      ],
    );
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
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              titleWidget(title),
              spaceWidget(10),
              statusDocument(),
              messagePaseMedico(),
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


