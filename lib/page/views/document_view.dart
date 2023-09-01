import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/document_identidad/document_identity_page.dart';
import 'package:sepcon_salud/page/pase_medico/init_pase_medico_page.dart';
import 'package:sepcon_salud/page/vacuum/home_vacuum.dart';
import 'package:sepcon_salud/page/vacuum/init_vacuum.dart';
import 'package:sepcon_salud/util/animation/circular_animation.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key});

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView>  with SingleTickerProviderStateMixin{
  late AnimationController progressController;
  late Animation animation;
  late String path;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPDFFile();
    progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween(begin: 0.0, end: 80.0).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [

                  // HEADER
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        GeneralWord.welcomeMessageHome,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                      )
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Anthony',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // INDICATOR
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GeneralColor.mainColor,
                    ),
                    height: 120,
                    child: Padding(
                      padding:const EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(GeneralWord.titleIndicatorHome
                                  ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text('16/24',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          CustomPaint(
                            foregroundPainter: CircleProgress(animation.value.toDouble()),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(child: Text(
                                "${animation.value.toInt()}%",style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),)),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),

                  // DOCUMENTS
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        GeneralWord.titleDocumentHome,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                        onTap: (){
                          routeDocumentIdentityPage();
                        },
                        leading: const  Icon(Icons.check_circle,color: GeneralColor.greenColor,),
                        title: const  Text(GeneralWord.identityDocumentHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                          onTap: (){
                            routeInitVaccinePage();
                          },
                        leading: const  Icon(Icons.check_circle,color: GeneralColor.greenColor,),
                        title: const   Text(GeneralWord.vacuumHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                          onTap: (){
                            routeHomePaseMedicoPage();
                          },
                          leading: const  Icon(Icons.check_circle,color: GeneralColor.greenColor,),
                          title: const  Text(GeneralWord.passMedicHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                          onTap: (){
                            print(GeneralWord.controlMedicHome);
                          },
                        leading: const  Icon(Icons.check_circle,color: GeneralColor.greenColor,),
                        title: const Text(GeneralWord.controlMedicHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),

                      )
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GeneralColor.grayBoldColor,
                      ),
                      child: ListTile(
                        onTap: (){
                          print(GeneralWord.covidHome);
                        },
                        leading:  const Icon(Icons.check_circle,color: GeneralColor.greenColor,),
                        title: const Text(GeneralWord.covidHome),
                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black54,),
                      )
                  ),

                ],
              ),
            ),
          )),
    );
  }

  routeDocumentIdentityPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DocumentIdentityPage()));
  }

  routeInitVaccinePage(){
    Navigator.push(
        context,
        MaterialPageRoute(
             builder: (context) => const InitVacuum()) );
            //builder: (context) => const HomeVacuum()));
  }
  routeHomeVaccinePage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeVacuum()));
  }

  routeHomePaseMedicoPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InitPaseMedicoPage()));
  }

  getPDFFile() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    path = prefs.getString('PDF_VACUNA')!;
    log(" PATH $path");
  }
}
