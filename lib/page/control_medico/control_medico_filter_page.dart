import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:opencv_brightness/edge_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sepcon_salud/page/covid/covid_carousel_page.dart';
import 'package:sepcon_salud/page/covid/covid_collect_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/edge_detection/edge_detector.dart';
import 'package:sepcon_salud/util/general_color.dart';

class ControlMedicoFilterPage extends StatefulWidget {
  final File file;
  final String titlePage;

  const ControlMedicoFilterPage({super.key,required this.file,required this.titlePage});

  @override
  State<ControlMedicoFilterPage> createState() => _ControlMedicoFilterPageState();
}

class _ControlMedicoFilterPageState extends State<ControlMedicoFilterPage> {

  late bool loading;
  late File normalFile;
  late File claroFile;
  late File magicFile;
  late String pathNormalFile;
  late String pathClaroFile;
  late String pathMagicFile;
  late String viewPhoto;
  late double? heightScreen;
  late double? widthScreen;
  late String title;
  late String mainPathPhoto;
  late LocalStore localStore;
  late String titlePhotoButton;
  late String titleFilterButton;
  late String keyDocument;
  late List<String> imgList;
  late List<String> titleList;

  @override
  void initState() {
    super.initState();
    initVariable();
    createFiles();
  }

  initVariable(){
    loading = false;
    title = widget.titlePage;
    localStore = LocalStore();
    titlePhotoButton = "Reintentar";
    titleFilterButton = "Confirmar";
    keyDocument = Constants.KEY_COVID;
    titleList =  Constants.titleListVacuum;
    imgList = Constants.imgListVacuum;
  }

  appBarWidget(){
    return AppBar(
        backgroundColor: loading ? Colors.black: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,
              color: loading ? Colors.white : Colors.black,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        )
    );
  }

  titleWidget(String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width:  widthScreen! * 0.6,
          child: Text(title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
              maxLines: 2,overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }

  mainImageWidget(String filePath){
    return Image.file(
      File(filePath),
      height:  heightScreen! * 0.3,
    );
  }

  filterImageWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // normal
        GestureDetector(
            onTap: (){
              setState(() {
                setState(() {
                  viewPhoto = pathNormalFile;
                });
              });
            },
            child:Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Stack(
                children: [
                  Image.file(
                    File(pathNormalFile),
                    width: widthScreen! * 0.28,
                  ),
                  Container(
                    width: widthScreen! * 0.28,
                    color: Colors.black38,
                    height: 20,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Normal',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,
                        ),),
                    ),
                  )
                ],
              ),
            )
        ),

        // claro
        GestureDetector(
          onTap: (){
            setState(() {
              viewPhoto = pathClaroFile;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                Image.file(
                  File(pathClaroFile),
                  width: widthScreen! * 0.28,
                ),
                Container(
                  width: widthScreen! * 0.28,
                  color: Colors.black38,
                  height: 20,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('Aclarar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                      ),),
                  ),
                )
              ],
            ),
          ),
        ),

        // magico
        GestureDetector(
          onTap: (){
            setState(() {
              viewPhoto = pathMagicFile;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                Image.file(
                  File(pathMagicFile),
                  width: widthScreen! * 0.28,
                ),
                Container(
                  width: widthScreen! * 0.28,
                  color: Colors.black38,
                  height: 20,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('Mágico',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                      ),),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  photoButtonWidget(String titleButton){
    return  GestureDetector(
      onTap: () {
        routeCarouselPage();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: GeneralColor.mainColor,
                  width: 2),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: GeneralColor.mainColor,
                  ),
                  Text(
                    titleButton,
                    style: TextStyle(
                        color: GeneralColor.mainColor,
                        fontSize: 16),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  appliedButtonWidget(String titleButton,String keyDocument){
    return   GestureDetector(
      onTap: (){
        saveLocalStoragePaths(keyDocument);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom:30),
        child: Container(
          padding: const EdgeInsets.only(top: 15,bottom: 15),
          //margin: const EdgeInsets.symmetric(horizontal: 15),
          //height: 50,
          decoration: BoxDecoration(
              color: GeneralColor.mainColor,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Text(
                titleButton,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16),
              )),
        ),
      ),
    );
  }

  loadWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [getLoadEffect()],
      ),
    );
  }
  saveLocalStoragePaths(String keyDocument) async {
    List<String> tempList = await localStore.fetchPathsFileByTypeDocument(
        keyDocument);
    tempList.add(viewPhoto);
    bool result = await localStore.saveFilePaths(
        keyDocument,tempList);
    if(result){
      routeCollectPage();
    }
  }

  createFiles() async {
    Uint8List bytes = widget.file.readAsBytesSync();

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);

    pathNormalFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_normal.png';
    normalFile = File(pathNormalFile);
    await normalFile.writeAsBytes(bytes);

    pathClaroFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_claro.png';
    claroFile = File(pathClaroFile);
    await claroFile.writeAsBytes(bytes);

    pathMagicFile  = '$dirPath/${(DateTime.now().millisecondsSinceEpoch / 1000).round()}_magic.png';
    magicFile = File(pathMagicFile);
    await magicFile.writeAsBytes(bytes);

    getMagicColor();

  }

  Future getMagicColor() async {
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
      return;
    }

    setState(() {
      imageCache.clearLiveImages();
      imageCache.clear();
      viewPhoto = pathMagicFile;
      loading = true;
    });
  }

  routeCollectPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const CovidCollectPage()));
  }

  routeCarouselPage(){
    Navigator.pushReplacement(
        context ,
        MaterialPageRoute(
            builder: (_) => CovidCarouselPage(
              titlePage: title,
              imgList: imgList,
              titleList: titleList,)));
  }

  spaceWidget(double space){
    return SizedBox(
      height: space,
    );
  }

  expandedWidget(){
    return const Expanded(
      child: SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: loading ? Colors.black : Colors.white,
      appBar: appBarWidget(),
      body: SafeArea(
          child: loading? Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                titleWidget(title),
                spaceWidget(20),
                mainImageWidget(viewPhoto),
                spaceWidget(20),
                filterImageWidget(),
                expandedWidget(),
                photoButtonWidget(titlePhotoButton),
                appliedButtonWidget(titleFilterButton,keyDocument),
              ],
            ),
          ) : loadWidget()) ,
    );
  }
}
