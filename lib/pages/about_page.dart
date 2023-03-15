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
        title: Text(widget.title),
      ),
      drawer: const NavBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('About Page'),
          ],
        ),
      ),
    );
  }
}
