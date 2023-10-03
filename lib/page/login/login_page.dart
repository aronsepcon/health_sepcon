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
import 'package:sepcon_salud/util/share_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final documentController = TextEditingController();
  final passwordController = TextEditingController();

  late LoginRepository loginRepository;
  late VacunaCostosRepository vacunaCostosRepository;
  late VacunaRepository vacunaRepository;
  LoginResponse? loginResponse;
  late bool isLoading;
  VacunaModel? vacunaModel;
  late LocalStore localStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVariable();
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
                        keyboardType: TextInputType.text,
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: (){
                        privacy();
                      },
                      child: const Center(
                        child: Text(
                          "Politica de Privacidad"
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  initVariable(){
    loginRepository = LoginRepository();
    vacunaRepository = VacunaRepository();
    vacunaCostosRepository = VacunaCostosRepository();
    isLoading = false;
    localStore = LocalStore();
  }

  privacy(){
    print("Privacidad");
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          content: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                InkWell(
                  onTap: (){
                    privacy();
                  },
                  child: IconButton(
                    icon: const Icon(
                    Icons.close_sharp,
                    color: Colors.red,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
            body: ListView(
              children: const [
                Column(
                  children: [
                    Text("Politica de Privacidad"),
                  ],
                )
              ],
            ),
          ),
        );
      });
  }

  authenticate() async {

    localStore.deleteUser();

    String documentValue = documentController.value.text;

    setState(() {
      isLoading = true;
    });

    loginResponse = await loginRepository.authenticate(
        documentValue, passwordController.value.text);

    if (loginResponse != null) {

      if (loginResponse!.nombres != null) {

        if (documentValue == '77100152') {
          loginResponse!.dni = '77100151';
        }

        localStore.saveUser(loginResponse!);

        DocumentVacunaModel? vacunaModel =
            await vacunaRepository.vacunaByDocument(loginResponse!.dni!);

        VacunaCostosModel? vacunaCostosModel = await vacunaCostosRepository
            .fetchVacunaByCentroCostos(loginResponse!.centroCostosId);

        if (vacunaModel != null && vacunaCostosModel != null) {
          routePage();
        }
      } else {
        setState(() {
          isLoading = false;
          widgetErrorDialog('Verificar el usuario o contraseña',context);
        });
      }
    }
  }

  routePage() {
    Navigator.push(
        context,RouteGenerator.generateRoute(const RouteSettings(name: '/homePage') ));
  }
}
