import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/document_identidad/pdf_container.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificadoVacuna extends StatefulWidget {
  final String path;
  const CertificadoVacuna({super.key,required this.path});

  @override
  State<CertificadoVacuna> createState() => _CertificadoVacunaState();
}

class _CertificadoVacunaState extends State<CertificadoVacuna> {

  late File file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    file = File(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [

                  // HEADER
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
                        'Certificado Vacunas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 550,child: PdfContainer(file: file,)),

                ],
              ),
            ),
          )),
    );
  }

}
