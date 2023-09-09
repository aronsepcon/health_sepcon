import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:sepcon_salud/page/document_identidad/document_success_page.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/repository/documento_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';

class DocumentPreviewPdfPage extends StatefulWidget {
  final File file;

  const DocumentPreviewPdfPage({super.key, required this.file});

  @override
  _DocumentPreviewPdfPageState createState() => _DocumentPreviewPdfPageState();
}

class _DocumentPreviewPdfPageState extends State<DocumentPreviewPdfPage> {
  late LoginResponse? loginResponse;
  late LocalStore localStore;
  late DocumentoRepository documentoRepository;
  bool loading = false, loadingPDF = false;
  String fileName = "";
  late double? heightScreen;
  late double? widthScreen;
  final dio = Dio();
  late double progressAnimation = 0.0;
  late int stateProgress = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localStore = LocalStore();
    documentoRepository = DocumentoRepository();
    fetchDataLocal();
  }

  @override
  Widget build(BuildContext context) {

    heightScreen = MediaQuery.of(context).size.height;
    widthScreen = MediaQuery.of(context).size.width;

    return loadingPDF
        ? Scaffold(
            backgroundColor: GeneralColor.mainColor,
            body: Center(
              child: SizedBox(
                height: heightScreen!,
                width: widthScreen,
                child: LiquidLinearProgressIndicator(
                    value: progressAnimation,
                    valueColor:
                        const AlwaysStoppedAnimation(GeneralColor.mainColor),
                    backgroundColor: Colors.white,
                    borderColor: GeneralColor.mainColor,
                    borderWidth: 0.0,
                    borderRadius: 0.0,
                    direction: Axis.vertical,
                    center: widgetSteps(stateProgress)),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )),
            body: SafeArea(
              child: !loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [getLoadEffect()],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vista previa',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                              height: heightScreen! * 0.6,
                              child: PdfContainer(
                                urlPdf: widget.file.path,
                                isLocal: true,
                                titlePDF: "Documento Identidad",
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          GestureDetector(
                            onTap: () {
                              //routePDFViewer(context);
                              savePDF();
                              //widgetShowProgress();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                //margin: const EdgeInsets.symmetric(horizontal: 15),
                                //height: 50,
                                decoration: BoxDecoration(
                                    color: GeneralColor.mainColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Subir PDF',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
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

  fetchDataLocal() async {
    loginResponse = await localStore.fetchUser();
    if (loginResponse != null) {
      setState(() {
        loading = true;
        fileName =
            "DNI-${loginResponse!.dni}-${loginResponse!.nombres!.replaceAll(" ", "")}.pdf";
      });
    }
  }

  savePDF() async {
    setState(() {
      loadingPDF = true;
    });
    dioProof(widget.file, fileName);
  }

  routePDFViewer(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DocumentSuccessPage()));
  }

  widgetErrorDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  dioProof(File filePdf, String filename) async {
    var bytesPdf = base64Encode(filePdf.readAsBytesSync());

    final formData = FormData.fromMap({
      'base64data': bytesPdf,
      'filename': filename,
    });

    final response = await dio.post(
        'https://rrhhperu.sepcon.net/medica_api/subidaApi.php',
        data: formData, onSendProgress: (int sent, int total) {
      log('send : $sent $total');
      setState(() {
        stateProgress = 1;
        progressAnimation = (sent.toDouble() / total.toDouble());
        if (progressAnimation == 1.0) {
          stateProgress = 2;
          progressAnimation += 0.1;
        }
      });
    }, onReceiveProgress: (int data1, int data2) {
      setState(() {
        log(" $data1 : $data2");
      });
    });

    log(response.toString());

    if (response.toString().isNotEmpty) {
     setState(() {
       stateProgress = 3;
     });
    }else{
      widgetErrorDialog("Volver a intentarlo");
      setState(() {
        loadingPDF = false;
      });
    }
  }

  Widget widgetSteps(int stateStep) {
    Widget step = Container();
    if (stateStep == 1) {
      var stateColor =
          progressAnimation < 0.5 ? GeneralColor.mainColor : Colors.white;
      step = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_rounded,
              color: stateColor,
              size: 100,
            ),
            SizedBox(
                width: widthScreen! * 0.7,
                child: Text(
                  "${(progressAnimation * 100).toInt()} %",
                  style: TextStyle(color: stateColor, fontSize: 20),
                  textAlign: TextAlign.center,
                )),
            Text(
              "1. Estamos enviando el PDF",
              style: TextStyle(color: stateColor, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (stateStep == 2) {
      step = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings_suggest_sharp,
                size: 100, color: Colors.white),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: widthScreen! * 0.8,
              child: const Text(
                "2. Esperar unos segundos que estamos validando el envío.",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else if (stateStep == 3) {
      step = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.white),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: widthScreen! * 0.7,
              child: const Text(
                "3. El envío del documento de identidad fue enviado con éxito",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                routeHomePage();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: widthScreen! * 0.7,
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                      color: GeneralColor.greenColor,
                      border: Border.all(color: GeneralColor.greenColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      Text(
                        'Inicio',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return step;
  }

  routeHomePage(){
    Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(
            builder: (context) => const HomePage(isRoot: true,)), (Route<dynamic> route) => false);
  }

}
