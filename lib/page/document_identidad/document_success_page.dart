import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/util/general_color.dart';

class DocumentSuccessPage extends StatefulWidget {
  const DocumentSuccessPage({super.key});

  @override
  State<DocumentSuccessPage> createState() => _DocumentSuccessPageState();
}

class _DocumentSuccessPageState extends State<DocumentSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,color: GeneralColor.greenColor,size: 100,),
            SizedBox(height: 40,),

            Text('Felicidades el envío fue exitoso',style: TextStyle(fontSize: 16),),
            SizedBox(height: 100,),
            GestureDetector(
              onTap: (){
                routePDFViewer(context);
              },
              child: Container(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                //height: 50,
                decoration: BoxDecoration(
                    color: GeneralColor.mainColor,
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                    child: Text(
                      'Volver al inicio',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  routePDFViewer(BuildContext context){
    Navigator.push(
        context ,
        MaterialPageRoute(
            builder: (context) =>const HomePage()));
  }
}
