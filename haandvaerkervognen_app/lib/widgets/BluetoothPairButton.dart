import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

///Button that show when you want to pair an alarm
class BluetoothPairButton extends StatefulWidget {
  BluetoothPairButton(
      {super.key,
      required this.minWidth,
      required this.minHeight,
      required this.maxWidth,
      required this.maxHeight,
      required this.fontSize,
      required this.username});

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final double fontSize;
  final String username;

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
  late String alarmData = '';

  late BluetoothConnection connection;
  late HttpService http = HttpService();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isScanning ? null : startBlueTooth,
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

  ///Starts discovering bluetooth devices and looks for the name "VAN ALARM"
  Future<List<String>> startBlueTooth() async {
    try {
      List<String> ids = List.empty(growable: true);
      setState(() {
        isScanning = true;
      });
      StreamSubscription streamSubscription =
          FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        if (r.device.name == 'VAN ALARM' && !ids.contains(r.device.address)) {
          if (!r.device.isBonded) {
            ids.add(r.device.address);
          }
        }
      });
      streamSubscription.onDone(() {
        FlutterBluetoothSerial.instance.cancelDiscovery();
        showBluetoothDiscoverDialog(ids);
        setState(() {
          isScanning = false;
        });
      });
      return ids;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      setState(() {
        isScanning = false;
      });
    }
    return List.empty();
  }

  ///Shows all the found devices with "VAN ALARM" as their name
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
            actions: [Center(child: Text('Ingen nye alarmer fundet.'))],
          );
        }
      },
    );
  }

  ///Tries bonding with a specified address
  bondWithAlarm(String alarmAddress) async {
    if (kDebugMode) {
      print('Bonding with: $alarmAddress');
    }
    if (!isBonded) {
      isBonded = (await FlutterBluetoothSerial.instance
          .bondDeviceAtAddress(alarmAddress))!;

      BluetoothConnection.toAddress(alarmAddress).then((btConn) {
        connection = btConn;
        connection.input!.listen((data) {
          _onDataReceived(data);
        });
      });
      showBluetoothInputDialog(alarmAddress);
    }
  }

  ///Shows the input dialog for pairing an alarm.
  ///You need to use the correct code to get an OK from the alarm
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
                      controller: widget.nameController,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [Text('Start'), Text('Slut')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      onPressed: () {
                        sendpairInfo(alarmAddress);
                        Navigator.pop(context);
                      },
                      child: const Text('Forbind')),
                ],
              )
            ],
          );
        },
      ).then((value) => Navigator.pop(context));
    }
  }

  ///Runs whenever you receive data from the paired alarm
  void _onDataReceived(Uint8List data) {
    if (kDebugMode) {
      print(ascii.decode(data));
    }
    alarmData += ascii.decode(data);

    if (ascii.decode(data).contains('!')) {
      connection.finish(); // Closing connection
      if (kDebugMode) {
        print('Disconnecting by local host');
      }
    }
  }

  handleError() {
    connection.close();
  }

  ///Sends the attempted password to the alarm and reads the response.
  ///If it contains a "!" it will send the pair information to the Api
  sendpairInfo(String alarmAddress) async {
    try {
      connection.output.add(Uint8List.fromList(
          utf8.encode("${widget.passwordController.text}\r\n")));
      await connection.output.done;
      if (alarmData.isNotEmpty && alarmData.contains('!')) {
        if (kDebugMode) {
          print(alarmData);
        }

        //create DTO and pop to main page
        bool result = await http.pairAlarm(
            widget.username,
            Alarm(
                alarmId: alarmAddress,
                startTime: startTime.format(context),
                endTime: endTime.format(context),
                name: widget.nameController.text));

        //Show result
        if (kDebugMode) {
          print('Did we bond successfully?: $result');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isBonded = false;
      FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(alarmAddress);
      connection.close();
    }
  }
}
