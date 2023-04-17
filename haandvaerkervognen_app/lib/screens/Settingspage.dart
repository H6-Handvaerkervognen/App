import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 15);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsPage'),
      ),
      body: Center(child: Text('Hey')),
    );
  }
}
