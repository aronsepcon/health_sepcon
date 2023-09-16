import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sepcon_salud/util/notification/firebase_options.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/notification/firebase_notification.dart';
import 'package:sepcon_salud/util/route.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: GeneralColor.mainColor),
        useMaterial3: true,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      //home: ProofDart(),
    );
  }
}
