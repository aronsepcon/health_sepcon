import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserSaveLocal();
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

  void routeSplash() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginPage()));
  }

  isUserSaveLocal() async {
    localStore = LocalStore();
    LoginResponse? loginResponse = await localStore.fetchUser();

    if(loginResponse != null){
      Navigator.pushReplacement(
          context,
          RouteGenerator.generateRoute(const RouteSettings(name: '/homePage'))
      );

    }else{
      Navigator.pushReplacement(
          context,
          RouteGenerator.generateRoute(const RouteSettings(name: '/loginPage'))
      );
    }
  }


}
