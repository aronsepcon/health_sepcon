import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfContainer extends StatefulWidget {
  final File file;
  const PdfContainer({super.key,required this.file});

  @override
  State<PdfContainer> createState() => _PdfContainerState();
}

class _PdfContainerState extends State<PdfContainer> {
  //late PDFViewController _controllerPDF;
  int pages = 0;
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      backgroundColor: Colors.black12,
      /*appBar: AppBar(
        leading: Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.white10,
        title: Text(name),
        actions: pages >= 2
            ? [
          Center(child: Text(text)),
          IconButton(
            icon: Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              final page = indexPage == 0 ? pages : indexPage - 1;
              _controllerPDF.setPage(page);
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 32),
            onPressed: () {
              final page = indexPage == pages - 1 ? 0 : indexPage + 1;
              _controllerPDF.setPage(page);
            },
          ),
        ]
            : null,
      ),*/
      body:Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12)
        ),
        child: SfPdfViewer.file(
            widget.file,
          scrollDirection: PdfScrollDirection.horizontal,
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        ),
      ),
    );
  }
}
