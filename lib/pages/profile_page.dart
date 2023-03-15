import 'package:flutter/material.dart';
import '../gui_componement/nav_bar.dart';

//create a stateful widget named ProfilePage
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  final String title = 'Profile';
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//create a state for the ProfilePage widget
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const NavBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Profile Page'),
          ],
        ),
      ),
    );
  }
}
