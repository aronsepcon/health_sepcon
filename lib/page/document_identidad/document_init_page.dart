import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/document_identidad/document_carousel_page.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/constantes.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';


class DocumentInitPage extends StatefulWidget {
  const DocumentInitPage({super.key});

  @override
  State<DocumentInitPage> createState() => _DocumentInitPageState();
}

class _DocumentInitPageState extends State<DocumentInitPage> {

  late LocalStore localStore;
  late double? heightScreen;
  late double? widthScreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVariable();
  }
  @override
  Widget build(BuildContext context) {

    heightScreen =  MediaQuery.of(context).size.height;
    widthScreen =  MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      GeneralWord.identityDocumentHome,
                      style: TextStyle(fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Image(image:AssetImage('assets/empty_document_identity.png'),
                  height: heightScreen! * 0.6 ,width: widthScreen! *0.8,),

                const Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  onTap: (){
                    routePage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      //margin: const EdgeInsets.symmetric(horizontal: 15),
                      //height: 50,
                      decoration: BoxDecoration(
                          color: GeneralColor.mainColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text(
                            'Iniciar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16),
                          )),
                    ),
                  ),
                ),
              ],
        ),
      )),
    );
  }

  initVariable(){
    localStore = LocalStore();
  }
  routePage() async {
    await localStore.deleteKey(Constants.KEY_DOCUMENTO_IDENTIDAD);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>DocumentCarouselPage(
              imgList: Constants.imgListDocumentFirst,
              titleList: Constants.titleListDocumentFirst,
              numberPage : Constants.DOCUMENT_FIRST,)));
  }

}
