
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/notification/background_message.dart';
import 'package:sepcon_salud/util/notification/custom_notification.dart';


class FirebaseApi{

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print(
            'Message title: ${message.notification?.title}, '
                'body: ${message.notification?.body}, data: ${message.data}');

        LocalStore localStore = LocalStore();
        DocumentVacunaModel? documentVacunaModel =
            await localStore.fetchVacunaGeneral();

        if(documentVacunaModel != null){
          final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
          CustomNotification.initialize(flutterLocalNotificationsPlugin);
          CustomNotification.showBigTextNotification(title: "New message title",
              body: "Your long body "
                  "${documentVacunaModel.documentoIdentidadModel!.adjunto}",
              fln: flutterLocalNotificationsPlugin);
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  showVacuumNotification() async {
    LocalStore localStore = LocalStore();
    List<VacunaModel> listRequiredVacuum = [];

    DocumentVacunaModel? documentVacuumModel = await localStore
        .fetchVacunaGeneral();

    VacunaCostosModel? vacunaCostosModel = await localStore.fetchVacunaCostos();

    if(documentVacuumModel != null && vacunaCostosModel != null){
      List<VacunaModel> vacuums = documentVacuumModel.vacunaGeneralModel!
          .tiposVacunas!;

      for(VacunaModel vacunaModel in vacuums){
        for(String vacuna in vacunaCostosModel.vacunas){
          if(vacuna == vacunaModel.nombre){
            listRequiredVacuum.add(vacunaModel);
          }
        }
      }

      // Lista final
      // Generar una cantidad de dias para que pueda vencer la vacuna

    }

  }
}