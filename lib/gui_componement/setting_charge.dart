//create a stateful widget named SettingCharge
import 'package:flutter/material.dart';
import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';

class SettingCharge extends StatefulWidget {
  const SettingCharge({super.key});
  @override
  State<SettingCharge> createState() => _SettingChargeState();
}

class _SettingChargeState extends State<SettingCharge> {
  var chargeMode = ['eco', 'normal', 'rapide'];
  String selectedChargeMode = 'normal';

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

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Form(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('choix de la borne de charge')),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('aucunne borne connetcé ')),
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
                  decoration: InputDecoration(labelText: 'Charge mode'),
                  value: selectedChargeMode,
                  items:
                      chargeMode.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedChargeMode = value.toString();
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: ElevatedButton(
                  onPressed: () {}, child: const Text('programmer la charge')),
            )
          ],
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

    debugPrint("${time!.hour}h${time.minute}");
    timesetter("${time.hour}h${time.minute}");
    controller.text = "${time.hour}h${time.minute}";

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
        "${duration!.inHours}h${duration.inMinutes.remainder(60)}";
  }
}
