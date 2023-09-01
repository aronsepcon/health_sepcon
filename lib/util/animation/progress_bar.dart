import 'package:flutter/material.dart';
import 'package:sepcon_salud/util/general_color.dart';

Widget getLoadEffect(){

  return Container(
    color: Colors.transparent,
    child:  const Padding(padding: const EdgeInsets.all(5.0),child: Center(child: CircularProgressIndicator(
      backgroundColor: GeneralColor.mainColor,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

    ))),
  );

}
