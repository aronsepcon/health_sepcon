
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sepcon_salud/util/general_color.dart';

class PaseMedicoFirstPage extends StatefulWidget {
  final List<File> file;

  const PaseMedicoFirstPage({super.key,required this.file});

  @override
  State<PaseMedicoFirstPage> createState() => _PaseMedicoFirstPageState();
}

class _PaseMedicoFirstPageState extends State<PaseMedicoFirstPage> {

  late File _image;
  List<File> listFile = [];


  final List<String> imgList = [
    'assets/pasemedico/pase_medico_reverso_1.png',
    'assets/pasemedico/pase_medico_reverso_2.PNG',
    'assets/pasemedico/pase_medico_reverso_2.PNG',
    'assets/pasemedico/pase_medico_reverso_2.PNG',
    'assets/document/document_frontal_4.png',
  ];
  final List<String> titleList = [
    '1. Posición correcta del documento',
    '2. Tomar foto',
    '3. Verificar foto',
    '4. Guardar foto',
    '5. Empezar a tomar la foto',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFile = widget.file;
    _image = File("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Primera cara',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                Image.file(
                  widget.file[0],
                  height: 400,
                  width: 400,
                ),

                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    // imgFromCamera(context);
                    routeSecondPage(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 15,bottom: 15),
                    //margin: const EdgeInsets.symmetric(horizontal: 15),
                    //height: 50,
                    decoration: BoxDecoration(
                        color: GeneralColor.mainColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text(
                          'Tomar reverso',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                ),


              ],
            ),
          )),
    );
  }

  imgFromCamera(BuildContext context) async {
    // IMAGE
    ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(image!.path);

    setState(() {
      _image;
      listFile.add(_image);
    });

  }


  routeSecondPage(BuildContext context){
    /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>ManuallyControllerSlider(imgList: imgList, titleList: titleList,listFile: listFile,numberWidget: 5,)));
  */
  }
}
