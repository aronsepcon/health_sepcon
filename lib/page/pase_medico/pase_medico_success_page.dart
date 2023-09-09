import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/repository/vacuna_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/general_color.dart';

class PaseMedicoSuccessPage extends StatefulWidget {
  const PaseMedicoSuccessPage({super.key});

  @override
  State<PaseMedicoSuccessPage> createState() => _PaseMedicoSuccessPageState();
}

class _PaseMedicoSuccessPageState extends State<PaseMedicoSuccessPage> {

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
                findUserLocalStorage();
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


  routeHomePage(){
    /*Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(
            builder: (context) => const HomePage()), (Route<dynamic> route) => false);*/
  }
  findUserLocalStorage() async {
    LocalStore localStore = LocalStore();
    VacunaRepository vacunaRepository = VacunaRepository();

    LoginResponse? loginResponse = await localStore.fetchUser();

    if(loginResponse != null){
      DocumentVacunaModel? vacuumModel =
      await vacunaRepository.vacunaByDocument(loginResponse.dni!);
      if(vacuumModel != null){
        routeHomePage();
      }
    }
  }
}
