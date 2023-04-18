import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/screens/AlarmSettingsPage.dart';
import 'package:haandvaerkervognen_app/widgets/BluetoothPairButton.dart';

class Frontpage extends StatefulWidget {
  const Frontpage({super.key});

  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Titel', style: TextStyle(fontSize: 30)),
        ),
        body: FutureBuilder<List<Alarm>>(
          future: someFutureFunctionReturningString(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Text('There was an error ${snapshot.error}');
            }
            if (snapshot.hasData) {
              //Generate elements
              List<Alarm> alarms = snapshot.data as List<Alarm>;
              if (alarms.isEmpty) {
                return const Center(
                    child: BluetoothPairButton(
                        minWidth: 200,
                        minHeight: 55,
                        maxWidth: 275,
                        maxHeight: 60));
              }
              return Center(
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        alarms.length,
                        (index) => ElevatedButton(
                          onPressed: () => goToAlarmSettings(alarms[index]),
                          child: Text(alarms[index].iD),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const BluetoothPairButton(
                        minWidth: 180,
                        minHeight: 40,
                        maxWidth: 190,
                        maxHeight: 50)
                  ],
                ),
              );
            }
            //Make pair widget
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Future<List<Alarm>> someFutureFunctionReturningString() async {
    List<Alarm> alarms = [
      Alarm(
          iD: 'isda1',
          startTime: TimeOfDay.now(),
          endTime: TimeOfDay.now(),
          name: 'Carstens bil'),
      Alarm(
          iD: 'Alarm 2',
          startTime: TimeOfDay.now(),
          endTime: TimeOfDay.now(),
          name: 'Jespers bil')
    ];

    await Future.delayed(Duration(seconds: 3));
    return alarms;
  }

  //tryAddAlarm(value) {}

  void goToAlarmSettings(Alarm alarm) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlarmSettingsPage(
                  alarm: alarm,
                )));
  }

  void searchForBtDevices() {}
}
