import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sepcon_salud/page/covid/covid_filter_page.dart';
import 'package:sepcon_salud/util/edge_detection/process_image.dart';
import 'package:sepcon_salud/util/general_color.dart';

class CovidCarouselPage extends StatefulWidget {
  final List<String> imgList;
  final List<String> titleList;
  final String titlePage;
  const CovidCarouselPage({super.key,required this.imgList, required this.titleList,required this.titlePage});


  @override
  State<CovidCarouselPage> createState() => _CovidCarouselPageState();
}

class _CovidCarouselPageState extends State<CovidCarouselPage> {

  late String? _imagePath;
  late CarouselController _controller;
  late int indexChange ;
  late double? heightScreen;
  late double? widthScreen;
  late String titleButton;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  // SETTING
  initVariable(){
    indexChange = 0 ;
    _controller = CarouselController();
    titleButton = "Tomar foto";
  }

  List<Widget> widgetCarousel(){
    List<Widget> listWidget = [];
    for(String path in widget.imgList){
      Widget container = Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.asset(path, fit: BoxFit.cover, width: 1000.0),
              ],
            )),
      );
      listWidget.add(container);
    }
    return listWidget;
  }

  openEdgeDetectionCamara() async {
    _imagePath = await ProcessImage.pathImage();
    if(_imagePath!.isNotEmpty){
      bool result = await ProcessImage.getImageFromCamera(_imagePath!);
      if(result){
        routeVacuumFilterPage();
      }
    }
  }

  titleWidget(String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width:  widthScreen! * 0.6,
          child: Text(title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
        )
      ],
    );
  }

  carouselWidget(){
    return CarouselSlider(
      items: widgetCarousel(),
      options: CarouselOptions(enlargeCenterPage: true,
          height: MediaQuery.of(context).size.height * 0.7,
          onPageChanged: (index,reason){
            setState(() {
              indexChange = index;
            });
          }),
      carouselController: _controller,
    );
  }

  buttonWidget(String titleButton){
    return GestureDetector(
      onTap: (){
        openEdgeDetectionCamara();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 15,bottom: 15),
        width: widthScreen! * 0.9,
        decoration: BoxDecoration(
            color: GeneralColor.mainColor,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_camera,color: Colors.white,),
                  Text(
                    titleButton,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  spaceWidget(double space){
    return SizedBox(
      height: space,
    );
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

  // REPLACE

  routeVacuumFilterPage(){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>
            CovidFilterPage(file: File(_imagePath!),titlePage: widget.titlePage,)));
  }

  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWidget(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  spaceWidget(10),
                  titleWidget(widget.titleList[indexChange]),
                  spaceWidget(10),
                  carouselWidget(),
                  buttonWidget(titleButton),
                ],
              ),
            ),
          ),
        ));
  }

}
