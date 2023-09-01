
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/page/document_identidad/document_first_page.dart';
import 'package:sepcon_salud/page/document_identidad/document_second_page.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_first_page.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_second_page.dart';
import 'package:sepcon_salud/page/vacuum/preview_vaccine.dart';
import 'package:sepcon_salud/util/general_color.dart';
/*
final List<String> imgList = [
  'assets/document/document_frontal_0.png',
  'assets/document/document_frontal_1.jpeg',
  'assets/document/document_frontal_2.jpeg',
  'assets/document/document_frontal_3.png',
  'assets/document/document_frontal_4.png',
];
final List<String> titleList = [
  '1. Posición correcta del documento',
  '2. Tomar foto',
  '3. Verificar foto',
  '4. Guardar foto',
  '5. Empezar a tomar la foto',
];
*/




class ManuallyControllerSlider extends StatefulWidget {
  final List<String> imgList;
  final List<String> titleList;
  final List<File> listFile;
  final int numberWidget;

  const ManuallyControllerSlider({super.key,
    required this.imgList, required this.titleList,
    required this.listFile, required this.numberWidget});


  @override
  State<ManuallyControllerSlider> createState() => _ManuallyControllerSliderState();
}

class _ManuallyControllerSliderState extends State<ManuallyControllerSlider> {
  String? _imagePath;
  late final EdgeDetection edgeDetection;
  final CarouselController _controller = CarouselController();
  int indexChange = 0 ;
  late String titleButton ;
  List<File> listFileLocal = [];
  final int INDEX_DOCUMENT = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleButton = "Siguiente";
    listFileLocal = widget.listFile;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 25,right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text(widget.titleList[indexChange],style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), maxLines: 2,overflow: TextOverflow.ellipsis,),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CarouselSlider(
                    items: widgetCarousel(),
                    options: CarouselOptions(enlargeCenterPage: true, height:MediaQuery.of(context).size.height*0.7,onPageChanged: (index,reason){
                      setState(() {
                        indexChange = index;
                        if(index == 4){
                          titleButton = "Iniciar";
                        }
                      });
                    }),
                    carouselController: _controller,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          if(indexChange != 4){
                            _controller.nextPage();
                          }
                          if(indexChange == 4){
                            getImageFromCamera(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 15,bottom: 15),
                          //margin: const EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width*0.8,
                          decoration: BoxDecoration(
                              color: GeneralColor.mainColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                child: Row(
                                  mainAxisAlignment: indexChange == 4 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                                  children: [
                                    indexChange == 4 ? Icon(Icons.photo_camera,color: Colors.white,) : Container(),
                                    Text(
                                      titleButton,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    indexChange == 4 ? Container() : Icon(Icons.arrow_forward,color: Colors.white,)
                                  ],
                                ),
                              )),
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> widgetCarousel(){
    List<Widget> listWidget = [];
    int index = 0;
    for(String path in widget.imgList){
      Widget container = Container(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(path, fit: BoxFit.cover, width: 1000.0),
                ],
              )),
        ),
      );

      listWidget.add(container);
    }
    return listWidget;
  }

  Future<void> getImageFromCamera(BuildContext buildContext) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    //String imagePath = join((await getApplicationSupportDirectory()).path,
    //    "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String  imagePath  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.png';


    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Enfocar el documento', // use custom localizations for android
        androidCropTitle: 'Verificar',
        androidCropBlackWhiteTitle: 'Blanco',
        androidCropReset: 'Reestablecer',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });

    listFileLocal.add(File(_imagePath!));
    if(widget.numberWidget == 1) {
      routeDocumentFirstPage(_imagePath!, buildContext);
    }else if(widget.numberWidget == 2){
      routeDocumentSecondPage(_imagePath!, buildContext);
    }else if(widget.numberWidget == 3){
      routePreViewVaccinePage(_imagePath!, buildContext);
    }else if(widget.numberWidget == 4){
      routePaseMedicoFirstPage(_imagePath!, buildContext);
    }else if(widget.numberWidget == 5){
      routePaseMedicoSecondPage(_imagePath!, buildContext);
    }

  }

  routeDocumentFirstPage(String path,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>DocumentFirstPage(file:listFileLocal)));
  }

  routeDocumentSecondPage(String path,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>DocumentSecondPage(file:listFileLocal)));
  }

  routePreViewVaccinePage(String path,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>PreviewVaccine(file:listFileLocal)));
  }

  routePaseMedicoFirstPage(String path,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>PaseMedicoFirstPage(file:listFileLocal)));
  }

  routePaseMedicoSecondPage(String path,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>PaseMedicoSecondPage(file:listFileLocal)));
  }
}
