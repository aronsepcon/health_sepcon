import 'package:flutter/material.dart';
import 'package:sepcon_salud/page/views/document_view.dart';
import 'package:sepcon_salud/page/views/exam_view.dart';
import 'package:sepcon_salud/page/views/perfil_view.dart';
import 'package:sepcon_salud/util/animation/circular_animation.dart';
import 'package:sepcon_salud/util/general_color.dart';
import 'package:sepcon_salud/util/general_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  int selectedIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final heightApp = MediaQuery.of(context).size.height;
    final views = [const DocumentView() ,
      const ExamView() ,
      PerfilView()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: selectedIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value){
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book  ),
            label: 'Documentos',
            backgroundColor: GeneralColor.mainColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.exposure_outlined),
              activeIcon: Icon(Icons.exposure_sharp),
              label: 'Examen',
              backgroundColor: GeneralColor.mainColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
              backgroundColor: GeneralColor.mainColor
          ),
        ],
      ),
    );
  }

}
