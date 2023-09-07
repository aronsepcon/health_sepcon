import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/page/vacuum/preview_vaccine.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CarouselVacuum extends StatefulWidget {
  final List<String> imgList;
  final List<String> titleList;
  final String titlePage;
  const CarouselVacuum({super.key,
    required this.imgList, required this.titleList,required this.titlePage});

  @override
  State<CarouselVacuum> createState() => _CarouselVacuumState();
}

class _CarouselVacuumState extends State<CarouselVacuum> {

  String? _imagePath;
  late final EdgeDetection edgeDetection;
  final CarouselController _controller = CarouselController();
  int indexChange = 0 ;
  late String titleButton = "Siguiente";
  List<File> listFileLocal = [];
  final int INDEX_DOCUMENT = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.arrow_back_ios),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 25,right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

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
                        if(index == INDEX_DOCUMENT){
                          titleButton = "Iniciar";
                        }
                      });
                    }),
                    carouselController: _controller,
                  ),

                  GestureDetector(
                    onTap: (){
                      if(indexChange != INDEX_DOCUMENT){
                        _controller.nextPage();
                      }
                      if(indexChange == INDEX_DOCUMENT){
                        getImageFromCamera(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      //margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width*0.9,
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreviewVaccine(file: File(imagePath),titlePage: widget.titlePage,)));
    });

  }

}
