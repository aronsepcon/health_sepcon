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
              children: [
                const Column(
                  children: [
                    Text("Politica de Privacidad",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.blue)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  children: [
                    Text('La presente Política de Privacidad establece los términos en que sepcon usa y protege la información que es proporcionada por sus usuarios al momento de utilizar su sitio web. Esta compañía está comprometida con la seguridad de los datos de sus usuarios. Cuando le pedimos llenar los campos de información personal con la cual usted pueda ser identificado, lo hacemos asegurando que sólo se empleará de acuerdo con los términos de este documento. Sin embargo esta Política de Privacidad puede cambiar con el tiempo o ser actualizada por lo que le recomendamos y enfatizamos revisar continuamente esta página para asegurarse que está de acuerdo con dichos cambios.')
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  children: [
                    Text("Uso de la información recogida",                      
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  children: [
                    Text("Nuestro sitio web emplea la información con el fin de proporcionar el mejor servicio posible, particularmente para mantener un registro de usuarios, de pedidos en caso que aplique, y mejorar nuestros productos y servicios.  Es posible que sean enviados correos electrónicos periódicamente a través de nuestro sitio con ofertas especiales, nuevos productos y otra información publicitaria que consideremos relevante para usted o que pueda brindarle algún beneficio, estos correos electrónicos serán enviados a la dirección que usted proporcione y podrán ser cancelados en cualquier momento. SEPCON está altamente comprometido para cumplir con el compromiso de mantener su información segura. Usamos los sistemas más avanzados y los actualizamos constantemente para asegurarnos que no exista ningún acceso no autorizado."),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  children: [
                    Text("Control de su información personal", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.blue)
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  children: [
                    Text("En cualquier momento usted puede restringir la recopilación o el uso de la información personal que es proporcionada a nuestro sitio web.  Cada vez que se le solicite rellenar un formulario, como el de alta de usuario, puede marcar o desmarcar la opción de recibir información por correo electrónico.  En caso de que haya marcado la opción de recibir nuestro boletín o publicidad usted puede cancelarla en cualquier momento.Esta compañía no venderá, cederá ni distribuirá la información personal que es recopilada sin su consentimiento, salvo que sea requerido por un juez con un orden judicial."),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                        child: Text(
                          "ACEPTAR"
                        ),
                      ),
                ),
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
