import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

///Page for changing settings concerning the alarm.
class AlarmSettingsPage extends StatefulWidget {
  AlarmSettingsPage({super.key, required this.alarm, required this.http});

  final Alarm alarm;
  final HttpService http;
  bool valueChanged = false;

  @override
  State<AlarmSettingsPage> createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  //Variables to control the TimePickerSpinner
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 15);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 30);
  final startTimeController = TimePickerSpinnerController();
  final endTimeController = TimePickerSpinnerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('SettingsPage - ${widget.alarm.name}')),
      ),
      body: Center(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 7),
            child: Text(
              'Alarm navn',
              style: TextStyle(fontSize: 32),
            ),
          ),
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
                          startTime = TimeOfDay.fromDateTime(dateTime);
                          widget.valueChanged = true;
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
                          // Implement your logic with select dateTime
                          setState(() {
                            endTime = TimeOfDay.fromDateTime(dateTime);
                            widget.valueChanged = true;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: widget.valueChanged ? saveChanges : null,
              child: const Text('Gem'))
        ],
      )),
    );
  }

  ///Saves the startTime and endTime by making a patch request to the Api
  void saveChanges() {
    setState(() async {
      widget.alarm.startTime = startTime;
      widget.alarm.endTime = endTime;

      bool response = await widget.http.saveAlarmTimes(widget.alarm);
      widget.valueChanged = false;
      //Show snackbar with result
    });
  }
}
