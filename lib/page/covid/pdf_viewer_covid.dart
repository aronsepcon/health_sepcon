import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/util/widget/pdf_container.dart';
import 'package:sepcon_salud/page/vacuum/successful_vacuum_page.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/repository/documento_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/general_color.dart';

class PdfViewerCovid extends StatefulWidget {
  final File file;

  const PdfViewerCovid({super.key,required this.file});

  @override
  State<PdfViewerCovid> createState() => _PdfViewerCovidState();
}


class _PdfViewerCovidState extends State<PdfViewerCovid> {
  late DocumentoRepository documentoRepository;
  late LocalStore localStore;
  late LoginResponse? loginResponse;
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
              SizedBox(height: 550,child: PdfContainer(
                urlPdf:  widget.file.path ,isLocal : true,
                titlePDF: "Certificado Vacuna",)),
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

  routePDFViewer(BuildContext context){
    Navigator.push(
        context ,
        MaterialPageRoute(
            builder: (context) =>const SuccesfulVacuumPage()));
  }
  fetchDataLocal() async {
    loginResponse = await localStore.fetchUser();
    if(loginResponse != null ){
      setState(() {
        fileName = "TV-${loginResponse!.dni}-${loginResponse!.nombres!.replaceAll(" ", "")}.pdf";
      });
    }
  }

  savePDF() async {
    bool result = await documentoRepository.saveDocument(fileName, widget.file);
    if(result){
      setState(() {
        routePDFViewer(context);
      });
    }else{
      log("error");
    }
  }

}
