import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/document_identidad/document_home_page.dart';
import 'package:sepcon_salud/page/document_identidad/document_identity_page.dart';
import 'package:sepcon_salud/page/home_page.dart';
import 'package:sepcon_salud/page/login/login_page.dart';
import 'package:sepcon_salud/page/splash_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case "/loginPage":
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case "/homePage":
        return MaterialPageRoute(builder: (_) => const HomePage());

      case "/documentoIdentidadInit":
        return MaterialPageRoute(builder: (_) =>
        const DocumentIdentityPage());

      case "/documentoIdentidadHome":
        return MaterialPageRoute(builder: (_) =>
        const DocumentHomePage(urlPdf: "",));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
