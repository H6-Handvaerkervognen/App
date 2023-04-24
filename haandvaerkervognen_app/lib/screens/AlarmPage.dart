import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/screens/AlarmSettingsPage.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';

///Page where you can stop the alarm and go into the settings of the alarm
class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key, required this.alarm, required this.http});

  final Alarm alarm;
  final HttpService http;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.alarm.name),
        ),
        actions: [
          //Settings button
          IconButton(
              onPressed: () => goToAlarmSettings(widget.alarm),
              icon: const Icon(Icons.settings))
        ],
      ),
      //Scrollview in case we view the page in landscape mode
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Stop alarm',
                  style: TextStyle(
                    fontSize: 50,
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(330, 400),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.black87),
                  onPressed: () => widget.http.stopAlarm(widget.alarm.iD),
                  child: const Icon(
                    Icons.stop_circle,
                    size: 300,
                  )),
            ],
          ),
        )),
      ),
    );
  }

  ///Goes to the AlarmSettingspage
  ///Parameters are the current alarm we are navigating to and a http object to save any changes
  void goToAlarmSettings(Alarm alarm) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlarmSettingsPage(
                  alarm: alarm,
                  http: widget.http,
                )));
  }
}
