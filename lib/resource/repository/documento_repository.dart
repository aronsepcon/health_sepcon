import 'dart:io';

import 'package:sepcon_salud/resource/api/documento_api.dart';

class DocumentoRepository{

  final documentoApi = DocumentoApi();

  Future<bool> saveDocument(String fileName,File filePdf) =>
      documentoApi.saveDocument(fileName, filePdf);

}