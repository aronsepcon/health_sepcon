import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/pase_medico/pase_medico_carousel_page.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';


class PaseMedicoInitPage extends StatefulWidget {
  const PaseMedicoInitPage({super.key});

  @override
  State<PaseMedicoInitPage> createState() => _PaseMedicoInitPageState();
}

class _PaseMedicoInitPageState extends State<PaseMedicoInitPage> {

  late double? heightScreen;
  late double? widthScreen;
  late String title;
  late String titleButton;
  late String pathIllustration;
  late List<String> imgList;
  late List<String> titleList;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  initVariable(){
    title = Constants.TITLE_PASE_MEDICO;
    titleButton = "Iniciar";
    pathIllustration = 'assets/empty_document_identity.png';
    imgList = Constants.imgListPaseMedicoFirst;
    titleList = Constants.titleListGeneral;
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

  illustrationWidget(String path){
    return Image(image: AssetImage(path),
      height: heightScreen! * 0.6 ,width: widthScreen! *0.8,);
  }

  buttonWidget(String titleButton){
    return GestureDetector(
      onTap: (){
        routePage();
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

  expandedWidget(){
    return const Expanded(
      child: SizedBox(),
    );
  }

  routePage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaseMedicoCarouselPage(
              imgList: imgList ,
              titleList: titleList,
              numberPage : Constants.DOCUMENT_FIRST,)));
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
