import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startLoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GeneralColor.mainColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                    onTap: () {
                      //routeSplash(context);
                    },
                    child: const Image(
                      image: AssetImage('assets/mainicon.png'),
                      height: 100,
                      width: 100,
                    )),
                const Column(
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

  startLoginPage(){
    Timer(Duration(seconds: 3), () {
      routeSplash();
    });
  }

}
