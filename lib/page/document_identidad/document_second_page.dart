import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/document_identidad/pdf_viewer_page.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentSecondPage extends StatefulWidget {
  final List<File> file;

  const DocumentSecondPage({super.key,required this.file});

  @override
  State<DocumentSecondPage> createState() => _DocumentSecondPageState();
}

class _DocumentSecondPageState extends State<DocumentSecondPage> {
  late File filePdf;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createPDFNew(widget.file);
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
                      'Segunda cara',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                Image.file(
                  widget.file[0],
                  height: 250,
                  width: 400,
                ),
                const SizedBox(height: 20,),
                Image.file(
                  widget.file[1],
                  height: 250,
                  width: 400,
                ),

                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    routePDFViewer();
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
                          'Generar PDF',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                ),


              ],
            ),
          )),
    );
  }

  createPDFNew(List<File> listFile) async {
    PdfDocument document = PdfDocument();
    //final page = document.pages.add();

    document.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData( listFile[0].path)),
        const Rect.fromLTWH(0, 0, 500, 350));

    document.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData( listFile[1].path)),
        const Rect.fromLTWH(0, 360, 500, 350));


    List<int> bytes = document.saveSync();
    document.dispose();
    saveAndLaunchFile(bytes);
  }

  Future<Uint8List> _readImageData(String name) async {
    File imageFile = File(name);
    return imageFile.readAsBytes();

  }

  Future<void> saveAndLaunchFile(List<int> bytes) async {
    DateTime now = DateTime.now();
    final output = await getTemporaryDirectory();
    filePdf = File("${output.path}/example${now.toString().trim()}.pdf");
    await filePdf.writeAsBytes(bytes, flush: true);
  }


  routePDFViewer(){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFViewerPage(file: filePdf )));
  }

}
