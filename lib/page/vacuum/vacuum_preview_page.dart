import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:sepcon_salud/page/document_identidad/document_carousel_page.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/custom_permission.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';

class VacuumPreviewPage extends StatefulWidget {

  final VacunaModel vacunaModel;

  const VacuumPreviewPage({super.key, required this.vacunaModel});

  @override
  State<VacuumPreviewPage> createState() => _VacuumPreviewPageState();
}

class _VacuumPreviewPageState extends State<VacuumPreviewPage>{
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();
  bool downloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  late LocalStore localStore;
  late bool isDownloading = false;
  late double? heightScreen;
  late double? widthScreen;

  @override
  void initState() {
    super.initState();
    checkPermission();
    fileName = "FV-${DateTime.now().millisecondsSinceEpoch}";

  }

  @override
  Widget build(BuildContext context) {
    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    'FICHA DE VACUNACION',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              statusDocument(),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: heightScreen! * 0.6,
                child: PdfContainer(
                  urlPdf: widget.vacunaModel.adjunto!,
                  isLocal: false,
                  titlePDF: titlePdf(),
                ),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: (){
                  if (!isDownloading) {
                    var fileName = "COVID-${DateTime.now().millisecondsSinceEpoch}";
                    downloadFile(fileName);
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
                                    backgroundColor: Colors.white,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            GeneralColor.mainColor),
                                  ),
                                  Text("${(progress * 100).toInt()}%",
                                    style: const TextStyle(
                                        fontSize: 12, color:  GeneralColor.mainColor,),
                                  )
                                ],
                        ) : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: GeneralColor.mainColor,
                                  ),
                                  Text(
                                    'Descargar',
                                    style: TextStyle(
                                        color: GeneralColor.mainColor,
                                        fontSize: 16),
                                  ),
                                ],
                            ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  routeDocumentCarouselPage();
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
                    child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            Text(
                              'Actualizar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  initVariable(){
    localStore = LocalStore();
  }

  routeDocumentCarouselPage() async {
    await localStore.deleteKey(Constants.KEY_DOCUMENTO_IDENTIDAD);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentCarouselPage(
                  imgList: Constants.imgListDocumentFirst,
                  titleList:  Constants.titleListGeneral,
                  numberPage: Constants.DOCUMENT_FIRST,
                )));
  }

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  downloadFile (String name){
    FileDownloader.downloadFile(
      url: '',
      name: name,
      onProgress: (String? fileName, double progressInput){
        setState(() {
          downloading = true;
          progress = (progressInput) / 100.00;
        });
      },
      onDownloadCompleted: (String path){
        var splitMessage = path.split("/");
        var message = splitMessage[splitMessage.length - 1];
        setState(() {
          downloading = false;
          isDownloading = false;
        });
      }
    );
  }

  widgetDirectoryDialog(String message){
    return showDialog(
      context: context, 
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            height: heightScreen! * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Icon(Icons.check_circle,color: GeneralColor.greenColor,size: 50,),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
      });



  }
  
    openfile(String path){
    OpenFile.open(path);
  }

  String titlePdf(){
    List<String> splitUrl = widget.vacunaModel.adjunto!.split("/");
    return splitUrl.last;
  }

  Widget statusDocument(){
    return const Row(
      children: [
        Icon(Icons.check_circle, color: GeneralColor.greenColor),
        Text('Verificado', style: TextStyle(color: GeneralColor.greenColor),)
      ],
    );
  }
}