import 'package:flutter/material.dart';
import 'package:pbr/gui_componement/nav_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  final String title = 'About';
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            Image.asset(
              'assets/logo/P_BR_white500.png',
              height: 100,
            ),
          ],
        ),
      ),
      drawer: const NavBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Cette application à été développé dans le cadre du module de projet coopératifs dispencé par l`école Polytech Paris-Saclay'),
              Text(
                  'Le projet qui nous à été confiée est la conception d\'une borne de recharge électrique pour véhicule électrique pilotable à distance'),
              Text(
                  'Elle à été developpé via le framework Flutter et se repose sur la librairie `flutter_bluetooth_serial` pour communiquer avec un modules Arduino HC-05 situé dans la borne de recharge'),
              Text(
                  '/!\\ La section des paramètre (Setting) de l\'application n\'est pas encore fonctionelle)'),
              Text(
                  '/!\\ L\application nécessite les autorisation suivante sur votre téléphone /!\\ \n - Bluetooth \n - Localisation \n Si vous refusez ces autorisation vous pourrez toujour les activer via les paramètres de votre téléphone.'),
              Text(
                  'En cas de diffculté n\'hésitez pas à nous contacter : \n - Email :kevin.leborgne@universite-paris-saclay.fr'),
              Text(
                  "L'ensemble des sources sont disponible sur le dépôt github suivant :"),
              //insérer l'image dont le path est lib/logo/P_BR_white500.png
              Image.asset('assets/logo/P_BR_white500.png',
                  width: 250, height: 250),
            ],
          ),
        ),
      ),
    );
  }
}
