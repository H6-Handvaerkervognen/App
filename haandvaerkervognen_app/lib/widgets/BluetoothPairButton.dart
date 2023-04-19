import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPairButton extends StatefulWidget {
  BluetoothPairButton(
      {super.key,
      required this.minWidth,
      required this.minHeight,
      required this.maxWidth,
      required this.maxHeight});
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  @override
  State<BluetoothPairButton> createState() => _BluetoothPairButtonState();
}

class _BluetoothPairButtonState extends State<BluetoothPairButton> {
  final passwordController = TextEditingController();

  late BluetoothConnection connection;
  bool isBonded = false;
  bool isScanning = false;
  late List<String> strings;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isScanning ? null : () => startBlueTooth(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        minimumSize: Size(widget.minWidth, widget.minHeight),
        maximumSize: Size(widget.maxWidth, widget.maxHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.bluetooth, size: 40),
          Spacer(flex: 1),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('Par ny alarm', style: TextStyle(fontSize: 30))),
          Spacer(flex: 2),
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
    //streamSubscription.onError(handleError);
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
            title: Text('Opret ny alarm'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Alarm navn'),
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
                      controller: passwordController,
                      decoration: InputDecoration(hintText: 'Kodeord'),
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Indtast venligst et kodeord';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          connection.output.add(Uint8List.fromList(
                              utf8.encode("${passwordController.text}\r\n")));
                          await connection.output.done;
                          if (alarmData.isNotEmpty && alarmData.contains('!')) {
                            print('$alarmData');
                            //create DTO and pop to main page
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
