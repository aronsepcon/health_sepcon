
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/page/document_identidad/document_first_page.dart';
import 'package:sepcon_salud/page/document_identidad/document_second_page.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class DocumentCarouselPage extends StatefulWidget {
  final List<String> imgList;
  final List<String> titleList;
  final int numberPage;

  const DocumentCarouselPage({super.key,
    required this.imgList, required this.titleList, required this.numberPage});


  @override
  State<DocumentCarouselPage> createState() => _DocumentCarouselPageState();
}

class _DocumentCarouselPageState extends State<DocumentCarouselPage> {

  late final EdgeDetection edgeDetection;
  late final CarouselController _controller;
  late int indexChange, INDEX_DOCUMENT;
  late String titleButton ;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Icon(Icons.arrow_back_ios),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text(widget.titleList[indexChange],
                          style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                          maxLines: 2,overflow: TextOverflow.ellipsis,),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CarouselSlider(
                    items: widgetCarousel(),
                    options: CarouselOptions(enlargeCenterPage: true,
                        height:MediaQuery.of(context).size.height*0.7,
                        onPageChanged: (index,reason){
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
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: indexChange == 4 ?
                              MainAxisAlignment.center
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                indexChange == INDEX_DOCUMENT ?
                                const Icon(Icons.photo_camera,color: Colors.white,)
                                    : Container(),
                                Text(
                                  titleButton,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                indexChange == INDEX_DOCUMENT ?
                                Container() : const
                                Icon(Icons.arrow_forward,color: Colors.white,)
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

  initVariable(){
    indexChange = 0 ;
    titleButton = "Siguiente";
    _controller = CarouselController();
    INDEX_DOCUMENT = 1;
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

    routeDocumentFirstPage(imagePath, context);
  }

  routeDocumentFirstPage(String path,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentFirstPage(file: File(path), numberPage: widget.numberPage,)));
  }


  deleteTemporaryDirectory() async {
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    dir.create();
  }

}
