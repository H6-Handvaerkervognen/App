import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

///Page for changing settings concerning the alarm.
class AlarmSettingsPage extends StatefulWidget {
  const AlarmSettingsPage({super.key, required this.alarm, required this.http});

  final Alarm alarm;
  final HttpService http;

  @override
  State<AlarmSettingsPage> createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  //Checks for any changes made to name, startTime or endTime
  bool valueChanged = false;
  //Variables to control the TimePickerSpinner
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 15);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 30);
  final startTimeController = TimePickerSpinnerController();
  final endTimeController = TimePickerSpinnerController();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController.fromValue(
            TextEditingValue(text: widget.alarm.name));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Indstillinger',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 7),
              //Editable textfield for the name
              child: TextField(
                controller: nameController,
                style: const TextStyle(fontSize: 32),
                onChanged: (value) {
                  setState(() {
                    widget.alarm.name = value;
                    valueChanged = true;
                  });
                },
              )),
          Text(
            widget.alarm.name,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 80,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Start'),
                      TimePickerSpinnerPopUp(
                        controller: startTimeController,
                        initTime: DateTime.now(),
                        barrierColor:
                            Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          setState(() {
                            startTime = TimeOfDay.fromDateTime(dateTime);
                            valueChanged = true;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Slut'),
                      TimePickerSpinnerPopUp(
                        mode: CupertinoDatePickerMode.time,
                        controller: endTimeController,
                        initTime: DateTime.now(),
                        minTime:
                            DateTime.now().subtract(const Duration(days: 10)),
                        maxTime: DateTime.now().add(const Duration(days: 10)),
                        barrierColor:
                            Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          setState(() {
                            endTime = TimeOfDay.fromDateTime(dateTime);
                            valueChanged = true;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            child: SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                  onPressed: valueChanged ? saveChanges : null,
                  child: const Text('Gem')),
            ),
          )
        ],
      )),
    );
  }

  ///Saves the startTime and endTime by making a patch request to the Api
  void saveChanges() {
    String snackBarText = "Temp";
    setState(() async {
      widget.alarm.startTime = startTime.format(context);
      widget.alarm.endTime = endTime.format(context);

      bool response = await widget.http.updateAlarmInfo(widget.alarm);
      valueChanged = false;
      //Show snackbar with result
      if (response) {
        snackBarText = "Registreringen gennemført!";
      } else {
        snackBarText = "Noget gik galt, registreringen fejlede";
      }
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarText)));
  }
}
