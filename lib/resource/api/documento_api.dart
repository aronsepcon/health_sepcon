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

    map['base64data'] = bytesPdf ;
    map['filename'] = fileName;

    DateTime now = DateTime.now();
    log("start2 : ${now.toString()}");

    final response = await client.post(url,body:map);
    if(response.statusCode==200){
      DateTime now2 = DateTime.now();
      log("end : ${now2.toString()}");
      log(response.body);
      //Map<String,dynamic> json = jsonDecode(response.body);
      log(json.toString());
      return true;
    }else{
      return false;
    }
  }

}