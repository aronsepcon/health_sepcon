import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_success_page.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/repository/documento_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';

class PaseMedicoPreviewPdfPage extends StatefulWidget {
  final File file;

  const PaseMedicoPreviewPdfPage({super.key, required this.file});

  @override
  _PaseMedicoPreviewPdfPageState createState() => _PaseMedicoPreviewPdfPageState();
}

class _PaseMedicoPreviewPdfPageState extends State<PaseMedicoPreviewPdfPage> {
  late LoginResponse? loginResponse;
  late LocalStore localStore;
  late DocumentoRepository documentoRepository;
  bool loading = false;
  String fileName = "";

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: !loading ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [getLoadEffect()],
          ),
        ) :Padding(
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
              SizedBox(height: 550,child: PdfContainer(
                urlPdf: widget.file.path, isLocal : true,
                titlePDF: "Documento Identidad",)),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  //routePDFViewer(context);
                  savePDF();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  //margin: const EdgeInsets.symmetric(horizontal: 15),
                  //height: 50,
                  decoration: BoxDecoration(
                      color: GeneralColor.mainColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
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
    if(loginResponse != null ){
      setState(() {
        loading = true;
        fileName = "PM-${loginResponse!.dni}-${loginResponse!.nombres!.replaceAll(" ", "")}.pdf";
        log("url : $fileName");
      });
    }
  }

  savePDF() async {
    loading = true;
    bool result = await documentoRepository.saveDocument(fileName, widget.file);

    if(result){
      setState(() {
        loading = false;
        routePDFViewer(context);
      });
    }else{
      widgetErrorDialog("Volver a intentarlo");
    }

  }

  routePDFViewer(BuildContext context){
    Navigator.pushReplacement(
        context ,
        MaterialPageRoute(
            builder: (context) =>const PaseMedicoSuccessPage()));
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
}