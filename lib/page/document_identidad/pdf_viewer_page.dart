import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/document_identidad/pdf_container.dart';
import 'package:sepcon_salud/page/successful_page.dart';
import 'package:sepcon_salud/util/general_color.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({super.key, required this.file});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {

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
              SizedBox(height: 550,child: PdfContainer(file: widget.file,)),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  routePDFViewer(context);
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
            builder: (context) =>const SuccessfulPage()));
  }
}