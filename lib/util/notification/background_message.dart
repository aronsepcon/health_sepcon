import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/notification/custom_notification.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  LocalStore localStore = LocalStore();
  DocumentVacunaModel? documentVacunaModel =
  await localStore.fetchVacunaGeneral();

  if(documentVacunaModel != null){
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    CustomNotification.initialize(flutterLocalNotificationsPlugin);
    CustomNotification.showBigTextNotification(title: "New message title",
        body: "Your long body ${documentVacunaModel.documentoIdentidadModel!.adjunto}", fln: flutterLocalNotificationsPlugin);
  }

  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

}