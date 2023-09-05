import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class DocumentoApi{

  var client = http.Client();

  Future<bool> saveDocument(String fileName,File filePdf) async{

    var url=Uri.parse('https://rrhhperu.sepcon.net/medica_api/subidaApi.php');
    var map = <String, dynamic>{};

    var bytesPdf = base64Encode(filePdf.readAsBytesSync()) ;
    //TV-77100151-JHONCURI.pdf

    map['base64data'] = bytesPdf ;
    map['filename'] = fileName;

    log('base64data : $bytesPdf');
    log('filename : $fileName');

    final response = await client.post(url,body:map);
    if(response.statusCode==200){
      log(response.body);
      //Map<String,dynamic> json = jsonDecode(response.body);
      log(json.toString());
      return true;
    }else{
      return false;
    }
  }

}