//create a stateful widget named SettingCharge

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';

class SettingCharge extends StatefulWidget {
  const SettingCharge({super.key});
  @override
  State<SettingCharge> createState() => _SettingChargeState();
}

class _SettingChargeState extends State<SettingCharge> {
  var chargeMode = ['eco', 'normal', 'rapide'];
  String selectedChargeMode = 'normal';
  int intensite = 8;
  String startTime = "";
  String endTime = "";
  Duration duration = const Duration();
  bool isSwitched = false;
  setDuration(Duration newDuartion) {
    setState(() {
      duration = newDuartion;
    });
  }

  setStartTime(String newStartTime) {
    setState(() {
      startTime = newStartTime;
    });
  }

  setEndTime(String newEndTime) {
    setState(() {
      endTime = newEndTime;
    });
  }

  String chargeMessage() {
    final f = new DateFormat('dd/MM/yyyy');
    String message;
    var now = DateTime.now();
    if (!isSwitched) {
      message =
          '$startTime $endTime ${intensite.toString().padLeft(2, '0')} ${f.format(now)}';
    } else {
      var end = TimeOfDay.fromDateTime(now.add(duration));

      message =
          '${now.hour.toString().padLeft(2, '0')}h${now.minute.toString().padLeft(2, '0')} ${end.hour.toString().padLeft(2, '0')}h${end.minute.toString().padLeft(2, '0')} ${intensite.toString().padLeft(2, '0')} ${f.format(now)}';
    }

    return message;
  }

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  /*BLE */ //
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool isDisconnecting = false;
  BluetoothDevice? _device;

  bool _connected = true;
  bool _isButtonUnavailable = false;
  bool get isConnected => connection != null && connection!.isConnected;
  late int _deviceState;
  List<BluetoothDevice> _devicesList = [];

  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _devicesList = devices;
    });
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });
  }

  void _sendMessageToBluetooth(String message) async {
    // ignore: prefer_adjacent_string_concatenation

    Uint8List convertStringToUint8List(String str) {
      final List<int> codeUnits = str.codeUnits;
      final Uint8List unit8List = Uint8List.fromList(codeUnits);

      return unit8List;
    }

    connection!.output.add(convertStringToUint8List(message));
    await connection!.output.allSent;
    debugPrint('Message send');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      //connection = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0;

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        getPairedDevices();
      });
    });
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
      _isButtonUnavailable;
    });
    if (_device == null) {
      debugPrint('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');

              setState(() {
                _connected = false;
                connection = null;
              });
            } else {
              print('Disconnected remotely!');
              setState(() {
                _connected = false;
                connection = null;
              });
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        debugPrint('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }
  /*                                  */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: ElevatedButton(
                    onPressed: () async {
                      var status = await Permission.nearbyWifiDevices.status;
                      if (status.isDenied) {
                        Permission.nearbyWifiDevices.request();
                        debugPrint(status.toString());
                        // We didn't ask for permission yet or the permission has been denied before but not permanently.
                      } else {
                        Permission.nearbyWifiDevices.request();
                      }

                      debugPrint(status.toString());
                      if (status.isGranted) {
                        _showDialog();
                      }
                    },
                    child: Text(!_connected
                        ? 'choix de la borne de charge'
                        : /*_device!.name.toString()*/ 'HC-05')),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                        _connected ? 'connecté' : 'aucunne borne connetcé ')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: !isSwitched
                            ? null
                            : () {
                                setState(() {
                                  isSwitched = !isSwitched;
                                });
                              },
                        child: const Text('horaire de charge')),
                    ElevatedButton(
                        onPressed: isSwitched
                            ? null
                            : () {
                                setState(() {
                                  isSwitched = !isSwitched;
                                });
                              },
                        child: const Text('temps de recharge')),
                  ],
                ),
              ),
              isSwitched
                  ? Center(
                      child: SizedBox(
                        width: 150,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: durationController,
                          onTap: () {
                            displayDurationPicker(
                                context, setDuration, durationController);
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Charge time',
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextField(
                            controller: startController,
                            onTap: () {
                              displayTimePicker(
                                  context, setStartTime, startController);
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Start time',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            controller: endController,
                            onTap: () {
                              displayTimePicker(
                                  context, setEndTime, endController);
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'End time',
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Charge mode'),
                    value: selectedChargeMode,
                    items: chargeMode
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedChargeMode = value.toString();
                        switch (value.toString()) {
                          case 'eco':
                            intensite = 8;
                            break;
                          case 'normal':
                            intensite = 16;
                            break;
                          case 'rapide':
                            intensite = 32;
                            break;
                          default:
                        }
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                    onPressed: !_connected
                        ? null
                        : () {
                            var message = chargeMessage();
                            debugPrint('intensité $intensite');
                            debugPrint('date début $startTime');
                            debugPrint('date de fin $endTime');
                            debugPrint('duréee $duration');
                            debugPrint('message de charge : $message');

                            _sendMessageToBluetooth(message);
                          },
                    child: const Text('programmer la charge')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future displayTimePicker(BuildContext context, Function timesetter,
      TextEditingController controller) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        });

    final f = new DateFormat('hh:mm');

    debugPrint("${time!.hour}h${time.minute}");
    timesetter(
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
    controller.text =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    //return "${time!.hour}h${time.minute}";
  }

  Future displayDurationPicker(BuildContext context, Function durationsetter,
      TextEditingController controller) async {
    var duration = await showDurationPicker(
        context: context,
        initialDuration: const Duration(hours: 2),
        durationPickerMode: DurationPickerMode.Day);

    durationsetter(duration);
    controller.text =
        "${duration!.inHours.toString().padLeft(2, '0')}h${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}";
  }

  //create a function to print a dialog who print all the device found
  void _showDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Liste des bornes de charge'),
              content: SizedBox(
                height: 300,
                width: 300,
                child: SingleChildScrollView(
                    child: Column(
                  children: _devicesList
                      .map((device) => ListTile(
                            title: Text(device.name == null
                                ? 'ici'
                                : device.name.toString()),
                            subtitle: Text(device.address.toString()),
                            onTap: () {
                              setState(() {
                                _device = device;
                              });
                              debugPrint(_device!.name.toString());
                              _connect();
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                )),
              ));
        });
  }
}
