import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/repository/vacuna_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';
import 'package:sepcon_salud/util/route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  late LocalStore localStore;
  late VacunaRepository vacunaRepository;

  @override
  void initState() {
    super.initState();
    initVariable();
    findUserLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: GeneralColor.mainColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 5,
                ),
                Image(
                  image: AssetImage('assets/mainicon.png'),
                  height: 100,
                  width: 100,
                ),
                Column(
                  children: [
                    Text(
                      GeneralWord.companyName,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      GeneralWord.version,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  initVariable(){
    vacunaRepository = VacunaRepository();
    localStore = LocalStore();
  }

  findUserLocalStorage() async {
    LoginResponse? loginResponse = await localStore.fetchUser();

    if(loginResponse != null){
      DocumentVacunaModel? vacuumModel =
      await vacunaRepository.vacunaByDocument(loginResponse.dni!);

      if(vacuumModel != null){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage(isRoot: false,))
        );
      }
    }else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
  }
}
