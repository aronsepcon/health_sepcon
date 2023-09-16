import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/covid/covid_carousel_page.dart';
import 'package:sepcon_salud/page/covid/covid_collect_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CovidInitPage extends StatefulWidget {
  const CovidInitPage({super.key});

  @override
  State<CovidInitPage> createState() => _CovidInitPageState();
}

class _CovidInitPageState extends State<CovidInitPage> {

  late double? heightScreen;
  late double? widthScreen;
  late String title;
  late String titleButton;
  late String pathIllustration;
  late List<String> imgList;
  late List<String> titleList;
  late LocalStore localStore;
  late String keyDocument;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  initVariable(){
    title = Constants.TITLE_COVID;
    keyDocument = Constants.KEY_COVID;
    titleButton = "Iniciar";
    pathIllustration = 'assets/medicine.png';
    imgList = Constants.imgListCovid;
    titleList = Constants.titleListGeneral;
    localStore = LocalStore();
  }

  appBarWidget(){
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  titleWidget(String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  titleBottomWidget(String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: widthScreen! * 0.8,
          child: Text(
            title,
            style: const
            TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  illustrationWidget(String path){
    return Image(image: AssetImage(path),
      height: heightScreen! * 0.6 ,width: widthScreen! *0.8,);
  }

  buttonWidget(String titleButton){
    return GestureDetector(
      onTap: (){
        widgetBottomSheet();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15,bottom: 15),
          decoration: BoxDecoration(
              color: GeneralColor.mainColor,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Text(
                titleButton,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ),
      ),
    );
  }


  galleryButtonWidget(String titleButton){
    return GestureDetector(
      onTap: () {
        findGalleryPhone();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: GeneralColor.mainColor),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo,
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

  takePhotoWidget(String titleButton){
    return  GestureDetector(
      onTap: (){
        routeCarouselPage();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          //margin: const EdgeInsets.symmetric(horizontal: 15),
          //height: 50,
          decoration: BoxDecoration(
              color: GeneralColor.mainColor,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                  Text(
                    titleButton,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  widgetBottomSheet(){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: widthScreen,
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Column(
                  children: [
                    titleBottomWidget("Tenemos dos opciones para subir los archivos"),
                    spaceWidget(20),
                    galleryButtonWidget("Subir fotos o archivos pdf"),
                    takePhotoWidget("Tomar una foto")
                  ],
                )
            ),
          ),
        );
      },
      isScrollControlled:true,
    );
  }

  findGalleryPhone() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((pathR) => File(pathR!)).toList();

      List<String> tempList = await localStore.fetchPathsFileByTypeDocument(keyDocument);

      for(File tempFile in files){
        tempList.add(tempFile.path);
      }

      bool resultFiles = await localStore.saveFilePaths(keyDocument,tempList);

      if(resultFiles){
        routeCollectPage();
      }

    } else {
      log("result null");
    }
  }

  routeCollectPage() async {
    Navigator.pushReplacement(
        context ,
        MaterialPageRoute(
            builder: (_) => const CovidCollectPage()));
  }

  routeCarouselPage() async {
    bool result = await localStore.deleteKey(keyDocument);
    if(result){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
              CovidCarouselPage(
                  imgList: imgList,
                  titleList: titleList, titlePage: title )));

    }
  }

  expandedWidget(){
    return const Expanded(
      child: SizedBox(),
    );
  }

  spaceWidget(double space){
    return SizedBox(
      height: space,
    );
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                titleWidget(title),
                illustrationWidget(pathIllustration),
                expandedWidget(),
                buttonWidget(titleButton),
              ],
            ),
          )),
    );
  }
}
