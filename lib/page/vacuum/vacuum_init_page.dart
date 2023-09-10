import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/vacuum/vacuum_carousel_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';

class VacuumInitPage extends StatefulWidget {
  const VacuumInitPage({super.key});

  @override
  State<VacuumInitPage> createState() => _VacuumInitPageState();
}

class _VacuumInitPageState extends State<VacuumInitPage> {

  late double? heightScreen;
  late double? widthScreen;
  late String title;
  late String titleButton;
  late String pathIllustration;

  @override
  void initState() {
    super.initState();
    initVariable();
  }

  initVariable(){
    title = Constants.TITLE_CERTIFICADO_VACUNA;
    titleButton = "Iniciar";
    pathIllustration = 'assets/medicine.png';
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
        routeCarouselPage();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
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

  // REPLACE
  routeCarouselPage() async {
    LocalStore localStore = LocalStore();
    bool result = await localStore.deleteKey(Constants.KEY_CERTIFICADO_VACUNA);
    if(result){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VacuumCarouselPage(
                imgList: Constants.imgListVacuum,
                titleList: Constants.titleListVacuum,titlePage: "Certificado de vacunas",)));
    }
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
            padding: EdgeInsets.only(left: 25, right: 25),
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
