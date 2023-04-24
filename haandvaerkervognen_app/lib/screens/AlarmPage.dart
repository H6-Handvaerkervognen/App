import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/screens/AlarmSettingsPage.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';

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
          IconButton(
              onPressed: () => goToAlarmSettings,
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
          child: Column(
        children: [
          const Text('Stop alarm'),
          ElevatedButton(
              onPressed: widget.http.stopAlarm(widget.alarm.iD),
              child: const Icon(Icons.stop_circle)),
        ],
      )),
    );
  }

  void goToAlarmSettings(Alarm alarm) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlarmSettingsPage(
                  alarm: alarm,
                )));
  }
}
