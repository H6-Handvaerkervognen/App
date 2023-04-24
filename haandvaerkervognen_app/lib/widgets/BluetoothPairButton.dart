import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class BluetoothPairButton extends StatefulWidget {
  BluetoothPairButton(
      {super.key,
      required this.minWidth,
      required this.minHeight,
      required this.maxWidth,
      required this.maxHeight,
      required this.fontSize});

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final double fontSize;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final startTimeController = TimePickerSpinnerController();
  final endTimeController = TimePickerSpinnerController();

  @override
  State<BluetoothPairButton> createState() => _BluetoothPairButtonState();
}

class _BluetoothPairButtonState extends State<BluetoothPairButton> {
  TimeOfDay startTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 12, minute: 0);
  bool isBonded = false;
  bool isScanning = false;

  late BluetoothConnection connection;
  late List<String> strings;
  late HttpService http;
  late Alarm newAlarm;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isScanning ? null : () => startBlueTooth();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        minimumSize: Size(widget.minWidth, widget.minHeight),
        maximumSize: Size(widget.maxWidth, widget.maxHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.bluetooth, size: 40),
          const Spacer(flex: 1),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('Par ny alarm',
                  style: TextStyle(fontSize: widget.fontSize))),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Future<List<String>> startBlueTooth() async {
    late List<String> ids = List.empty(growable: true);
    isScanning = true;
    StreamSubscription streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      isScanning = true;
      if (r.device.name == 'VAN ALARM' && !ids.contains(r.device.address)) {
        if (!r.device.isBonded) {
          ids.add(r.device.address);
        }
      }
    });
    streamSubscription.onDone(() {
      FlutterBluetoothSerial.instance.cancelDiscovery();
      showBluetoothDiscoverDialog(ids);
      isScanning = false;
    });
    return ids;
  }

  void showBluetoothDiscoverDialog(List<String> strings) {
    showDialog(
      context: context,
      builder: (context) {
        if (strings.isNotEmpty) {
          return AlertDialog(
            actions: [
              Center(
                child: FittedBox(
                  child: Column(
                    children: List.generate(
                        strings.length,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () =>
                                      bondWithAlarm(strings[index]),
                                  child: Text(strings[index])),
                            )),
                  ),
                ),
              )
            ],
          );
        } else {
          return const AlertDialog(
            actions: [Text('Ingen nye alarmer fundet')],
          );
        }
      },
    );
  }

  bondWithAlarm(String alarmAddress) async {
    print('Bonding with: $alarmAddress');
    isBonded = (await FlutterBluetoothSerial.instance
        .bondDeviceAtAddress(alarmAddress))!;

    BluetoothConnection.toAddress(alarmAddress).then((_connection) {
      connection = _connection;
      connection.input!.listen((data) {
        _onDataReceived(data);
      });
    });
    showBluetoothInputDialog(alarmAddress);
  }

  Future<void> showBluetoothInputDialog(String alarmAddress) async {
    if (isBonded) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Opret ny alarm'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: 'Alarm navn'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Angiv venligst et Alarm navn';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: widget.passwordController,
                      decoration: const InputDecoration(hintText: 'Kodeord'),
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Indtast venligst et kodeord';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Text('Alarm tider'),
                  Row(
                    children: const [Text('Start'), Text('Slut')],
                  ),
                  Row(
                    children: [
                      TimePickerSpinnerPopUp(
                        initTime: DateTime.now(),
                      ),
                      TimePickerSpinnerPopUp(
                        controller: widget.startTimeController,
                        initTime: DateTime.now(),
                        barrierColor:
                            Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          // Implement your logic with select dateTime
                          startTime = TimeOfDay.fromDateTime(dateTime);
                        },
                      ),
                      TimePickerSpinnerPopUp(
                        controller: widget.endTimeController,
                        initTime: DateTime.now(),
                        barrierColor:
                            Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          endTime = TimeOfDay.fromDateTime(dateTime);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          connection.output.add(Uint8List.fromList(utf8.encode(
                              "${widget.passwordController.text}\r\n")));
                          await connection.output.done;
                          if (alarmData.isNotEmpty && alarmData.contains('!')) {
                            print('$alarmData');
                            //create DTO and pop to main page
                            http = HttpService();
                            http.savePairing(
                                'GetAppID',
                                Alarm(
                                    iD: alarmAddress,
                                    startTime: startTime,
                                    endTime: endTime,
                                    name: widget.nameController.text));

                            FlutterBluetoothSerial.instance
                                .removeDeviceBondWithAddress(alarmAddress);
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        } finally {
                          connection.close();
                        }
                      },
                      child: const Text('Forbind')),
                ],
              )
            ],
          );
        },
      );
    }
  }

  late String alarmData = '';

  void _onDataReceived(Uint8List data) {
    print(ascii.decode(data));
    alarmData += ascii.decode(data);

    if (ascii.decode(data).contains('!')) {
      connection.finish(); // Closing connection
      print('Disconnecting by local host');
    }
  }

  handleError() {
    connection.close();
  }
}
