import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/document_identidad/pdf_viewer_page.dart';
import 'package:sepcon_salud/page/vacuum/pdf_viewer_vacuum.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PreviewVaccine extends StatefulWidget {
  final List<File> file;

  const PreviewVaccine({super.key,required this.file});

  @override
  State<PreviewVaccine> createState() => _PreviewVaccineState();
}

class _PreviewVaccineState extends State<PreviewVaccine> {

  late File _image;
  List<File> listFile = [];
  late File filePdf;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFile = widget.file;
    _image = File("");
    filePdf = File("");
    //createPDF(listFile);
    createPDFNew();
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
                      'Tarjeta de vacuna ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                Image.file(
                  widget.file[0],
                  height: 400,
                  width: 400,
                ),

                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    print(filePdf.path);
                    routePDFViewer();
                    // imgFromCamera(context);
                    //routeSecondPage(context);

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
          )),
    );
  }

 /* createPDF(List<File> listFile) async {
    final pdf = pw.Document();

    // PDF
    final firstImage = pw.MemoryImage(
      listFile[0].readAsBytesSync(),
    );



    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Column(
            children: [
              pw.Image(firstImage,
                height: 1000,
                width: 1000)

            ]
        ),
      ); // Center
    })); // Page

    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
    DateTime now = DateTime.now();
    final output = await getTemporaryDirectory();
    filePdf = File("${output.path}/example${now.toString().trim()}.pdf");
    await filePdf.writeAsBytes(await pdf.save());

  }*/

  createPDFNew() async {
    PdfDocument document = PdfDocument();
    //final page = document.pages.add();

    //Set the page size
    //document.pageSettings.size = PdfPageSize.a4;

    //Change the page orientation to landscape
    document.pageSettings.orientation = PdfPageOrientation.landscape;

    document.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData( listFile[0].path)),
    const Rect.fromLTWH(0, 0, 750, 500));

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
            builder: (context) => PdfViewerVacuum(file: filePdf )));
  }

}
