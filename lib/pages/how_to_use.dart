import 'package:flutter/material.dart';
import '../gui_componement/nav_bar.dart';

//create a stateful widget named How_to_usePage
class How_to_usePage extends StatefulWidget {
  const How_to_usePage({super.key});
  final String title = 'how to use';
  @override
  State<How_to_usePage> createState() => _How_to_usePageState();
}

//create a state for the How_to_usePage widget
class _How_to_usePageState extends State<How_to_usePage> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Mode d\'emploi :'),
              Text('1-Deconnecter votre véhicule de la borne'),
              Text('2-Selectionner la borne via l\'onglet dédié'),
              Text('3-Selectionner les horaires de recharge ou un '),
              Text('temps de  recherge si  vous voulez commencez la '),
              Text('recharge immédiatement'),
              Text('4- Séléctionner un mode de recharge'),
              Text('5- Lancer la recharge de votre véhicule'),
              Text('6- Brancher votre véhicule à la borne'),
            ],
          ),
        ),
      ),
    );
  }
}
