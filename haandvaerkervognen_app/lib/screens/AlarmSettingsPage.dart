import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class AlarmSettingsPage extends StatefulWidget {
  const AlarmSettingsPage({super.key, required this.alarm});

  final Alarm alarm;

  @override
  State<AlarmSettingsPage> createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 15);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 30);
  final startTimeController = TimePickerSpinnerController();
  final endTimeController = TimePickerSpinnerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsPage: - ${widget.alarm.name}'),
      ),
      body: Center(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Alarm navn',
              style: TextStyle(fontSize: 32),
            ),
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
                      Text('Start'),
                      TimePickerSpinnerPopUp(
                        controller: startTimeController,
                        initTime: DateTime.now(),
                        barrierColor:
                            Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          // Implement your logic with select dateTime
                          startTime = TimeOfDay.fromDateTime(dateTime);
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Slut'),
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
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          ElevatedButton(onPressed: saveChanges, child: const Text('Gem'))
        ],
      )),
    );
  }

  void saveChanges() {
    //Save startTime and endTime
  }
}
