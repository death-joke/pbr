import 'package:flutter/material.dart';
import 'package:pbr/gui_componement/nav_bar.dart';
import 'package:pbr/gui_componement/setting_charge.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const NavBar(),
      body: const SettingCharge(),
    );
  }
}
