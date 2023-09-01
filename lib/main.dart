

import 'package:flutter/material.dart';
import 'package:opencv_brightness/edge_detection.dart';
import 'package:sepcon_salud/camera_detector/scan.dart';
import 'package:sepcon_salud/edge_detection/edge_detector.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/page/splash_page.dart';
import 'package:sepcon_salud/util/general_color.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: GeneralColor.mainColor),
        useMaterial3: true,
      ),
     // home: const EdgePhoto(),
     // home: Scan(),
      home: const LoginPage(),
      //home: const SuccessfulPage(),
      //home: CameraApp()
      //home: OpenCVSimulate(),
    );
  }
}


