import 'dart:io';

import 'package:flutter/services.dart';
import 'package:opencv_brightness/edge_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/util/edge_detection/edge_detector.dart';

class ProcessImage{

  Future<bool> initProcessImage(Uint8List bytes) async {

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);

    String pathNormalFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_normal.png';
    File normalFile = File(pathNormalFile);
    await normalFile.writeAsBytes(bytes);

    String pathClaroFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_claro.png';
    File claroFile = File(pathClaroFile);
    await claroFile.writeAsBytes(bytes);

    String pathMagicFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_magic.png';
    File magicFile = File(pathMagicFile);
    await magicFile.writeAsBytes(bytes);

    bool result = await getMagicColor(pathMagicFile, pathClaroFile);

    return result;
  }

  Future<bool> getMagicColor(String pathMagicFile,String pathClaroFile) async {
    Offset topLeft = const Offset(0.0, 0.0);
    Offset topRight = const Offset(1.0, 0.0);
    Offset bottomLeft = const Offset(0.0, 1.0);
    Offset bottomRight = const Offset(1.0, 1.0);

    EdgeDetectionResult edgeDetectionResult = EdgeDetectionResult(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight);

    bool resultMagic = await EdgeDetector().processImage(pathMagicFile,edgeDetectionResult);

    bool resultClaro = await EdgeDetector().processImageLight(pathClaroFile, edgeDetectionResult);

    if (resultMagic == false && resultClaro == false) {
      return false;
    }

    return true;
  }

  Future<String> generatePath() async {
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);

    String path = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_normal.png';
    return path;
  }

}