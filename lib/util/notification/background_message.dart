import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/dosis_model.dart';
import 'package:sepcon_salud/resource/model/refuerzo_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/helper.dart';
import 'package:sepcon_salud/util/notification/custom_notification.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  LocalStore localStore = LocalStore();
  DocumentVacunaModel? documentVacunaModel =
  await localStore.fetchVacunaGeneral();

  if(documentVacunaModel != null){
    //Helper.editValue(documentVacunaModel.vacunaGeneralModel!.tiposVacunas!);
    Helper.validateDates(documentVacunaModel.vacunaGeneralModel!.tiposVacunas!);
    String message = "\n";
    for(VacunaModel vacunaModel in documentVacunaModel.vacunaGeneralModel!.tiposVacunas!){
      if(vacunaModel.vigenciaVacuna == VigenciaVacuna.noActive){
        message += "${vacunaModel.nombre} : ${vacunaModel.amountDay} día(s) vencidos \n";

      }
      if( vacunaModel.vigenciaVacuna == VigenciaVacuna.toExpire){
        message += "${vacunaModel.nombre} : ${vacunaModel.amountDay} día(s) para vencer  \n";
      }
    }

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    CustomNotification.initialize(flutterLocalNotificationsPlugin);
    CustomNotification.showBigTextNotification(title: "Sepcon Salud",
        body: message, fln: flutterLocalNotificationsPlugin);


  }

  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}


