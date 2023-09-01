import 'package:flutter/material.dart';
import 'package:sepcon_salud/resource/model/document_vacuna_model.dart';
import 'package:sepcon_salud/resource/model/login_response.dart';
import 'package:sepcon_salud/resource/model/vacuna_costos_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';
import 'package:sepcon_salud/resource/repository/login_repository.dart';
import 'package:sepcon_salud/resource/repository/vacuna_costos_repository.dart';
import 'package:sepcon_salud/resource/repository/vacuna_repository.dart';
import 'package:sepcon_salud/resource/share_preferences/local_store.dart';
import 'package:sepcon_salud/util/animation/progress_bar.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';
import 'package:sepcon_salud/util/route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final documentController = TextEditingController();
  final passwordController = TextEditingController();

  late LoginRepository loginRepository;
  bool isLoading = false;

  LoginResponse? loginResponse;

  late VacunaRepository vacunaRepository;
  VacunaModel? vacunaModel;

  late VacunaCostosRepository vacunaCostosRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initSharedPreferences();
    loginRepository = LoginRepository();
    vacunaRepository = VacunaRepository();
    vacunaCostosRepository = VacunaCostosRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [getLoadEffect()],
                )
              : Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const Image(
                      image: AssetImage('assets/main_icon_color.png'),
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      GeneralWord.titleLogin,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      GeneralWord.subtitleLogin,
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: documentController,
                        obscureText: false,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: GeneralColor.grayColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            fillColor: Colors.white,
                            hintText: 'Documento',
                            filled: true),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: GeneralColor.grayColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            fillColor: Colors.white,
                            enabled: true,
                            hintText: 'Contraseña',
                            filled: true),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        authenticate();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        //height: 50,
                        decoration: BoxDecoration(
                            color: GeneralColor.mainColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                            child: Text(
                          GeneralWord.buttonTextLogin,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(25),
                      child: SizedBox(
                        child: Text(
                          GeneralWord.textLogin,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  void authenticate() async {
    String documentValue = documentController.value.text;


    setState(() {
      isLoading = true;
    });
    loginResponse = await loginRepository.authenticate(
        documentValue, passwordController.value.text);

    if (loginResponse != null) {
      if (loginResponse!.nombres != null) {
        if (documentValue == '77100152') {
          documentValue = '77100151';
        }
        LocalStore localStore = LocalStore();
        localStore.saveUser(loginResponse!);

        DocumentVacunaModel? vacunaModel =
            await vacunaRepository.vacunaByDocument(documentValue);

        VacunaCostosModel? vacunaCostosModel =
        await vacunaCostosRepository
            .fetchVacunaByCentroCostos(loginResponse!.centroCostosId);

        if (vacunaModel != null && vacunaCostosModel != null) {

          routeHome();
        }
      } else {
        setState(() {
          isLoading = false;
          widgetErrorDialog('Verificar el usuario o contraseña');
        });
      }
    }
  }

  widgetErrorDialog(String message) {
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

  routeHome() {
    Navigator.push(
        context,RouteGenerator.generateRoute(const RouteSettings(name: '/homePage') ));
  }

}
