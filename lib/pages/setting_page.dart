import 'package:flutter/material.dart';
import 'package:pbr/gui_componement/nav_bar.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  final String title = 'Settings';
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var status = Permission.location.status;
  bool isBtEnable = true;
  bool isBtPerm = true;
  bool isLocalisationPerm = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Settings Page'),
            Row(
              children: [
                const Text('activer le bluetooth : '),
                Switch(
                    value: isBtPerm,
                    onChanged: (bool value) => setState(() {
                          isBtPerm = value;
                        }))
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const Text('Permissions'),
            Row(
              children: [
                const Text('Autorisation d\'utiliser le bluetooth : '),
                Switch(
                    value: isLocalisationPerm,
                    onChanged: (bool value) => setState(() {
                          isLocalisationPerm = value;
                        }))
              ],
            ),
            Row(
              children: [
                const Text('Autorisation d\'utiliser la localistion : '),
                Switch(
                    value: isBtEnable,
                    onChanged: (bool value) => setState(() {
                          isBtEnable = value;
                        }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
