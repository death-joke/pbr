import 'package:flutter/material.dart';
import 'package:pbr/gui_componement/nav_bar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  final String title = 'Settings';
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
            Text('Settings Page'),
          ],
        ),
      ),
    );
  }
}
