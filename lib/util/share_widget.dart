import 'package:flutter/material.dart';
import 'package:sepcon_salud/util/general_color.dart';

widgetErrorDialog(String message,BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    },
  );
}

widgetDirectoryDialog(String message,BuildContext context,double heightScreen) {
  return showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.white,
        child: Container(
          height: heightScreen! * 0.3,
          decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              const Icon(Icons.check_circle,color: GeneralColor.greenColor,size: 50,),
              const Text(
                "El PDF fue almacenado en la carpeta de descarga como :",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    },
  );
}
