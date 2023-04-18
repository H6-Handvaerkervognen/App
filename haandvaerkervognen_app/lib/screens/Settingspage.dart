import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 15);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 30);
  final startTimeController = TimePickerSpinnerController();
  final endTimeController = TimePickerSpinnerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsPage'),
      ),
      body: Center(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Alarm id',
              style: TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(
            height: 150,
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
