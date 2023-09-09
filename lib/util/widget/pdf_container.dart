import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfContainer extends StatefulWidget {
  final String urlPdf;
  final bool isLocal;
  final String titlePDF;

  const PdfContainer({super.key,required this.urlPdf,
    required this.isLocal,required this.titlePDF});

  @override
  State<PdfContainer> createState() => _PdfContainerState();
}

class _PdfContainerState extends State<PdfContainer> {

  late bool typePDF;
  late File file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVariable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        leading: const Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.white24,
        title: Text(widget.titlePDF),
      ),
      body:Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12)
        ),
        child: widget.isLocal ? SfPdfViewer.file(
            file,
          scrollDirection: PdfScrollDirection.vertical,
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        )  : SfPdfViewer.network(widget.urlPdf),
      ),
    );
  }

  initVariable(){
    file = File(widget.urlPdf);
  }

}
