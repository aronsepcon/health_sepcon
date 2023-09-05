import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfContainer extends StatefulWidget {
  final File file;
  final String urlPdf;
  final String fontFile;
  final String titlePDF;
  const PdfContainer({super.key,required this.file,required this.urlPdf,
    required this.fontFile,required this.titlePDF});

  @override
  State<PdfContainer> createState() => _PdfContainerState();
}

class _PdfContainerState extends State<PdfContainer> {
  late PdfViewerController _controllerPDF;

  int pages = 0;
  int indexPage = 0;
  late bool typePDF;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.fontFile == "NETWORK"){
      typePDF = false;
    }else if(widget.fontFile == "LOCAL"){
      typePDF = true;
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        leading: Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.white10,
        title: Text(widget.titlePDF),
      ),
      body:Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12)
        ),
        child: typePDF ? SfPdfViewer.file(
            widget.file,
          scrollDirection: PdfScrollDirection.horizontal,
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        )  : SfPdfViewer.network(widget.urlPdf),
      ),
    );
  }
}
