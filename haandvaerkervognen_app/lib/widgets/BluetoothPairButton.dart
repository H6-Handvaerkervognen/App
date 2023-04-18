import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPairButton extends StatelessWidget {
  const BluetoothPairButton(
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
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            List<DiscoveredDevice> devices = startBlueTooth();
            return Column(
                children: List.generate(
                    devices.length, (index) => Text(devices[index].name)));
          }),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        minimumSize: Size(minWidth, minHeight),
        maximumSize: Size(maxWidth, maxHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.bluetooth, size: 40),
          Spacer(flex: 1),
          Text('Par ny alarm', style: TextStyle(fontSize: 30)),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  List<DiscoveredDevice> startBlueTooth() {
    Permission.bluetoothScan.request();
    Permission.bluetoothConnect.request();
    Permission.location.request();
    final flutterReactiveBle = FlutterReactiveBle();
    final List<DiscoveredDevice> devicesList = List.empty(growable: true);
    flutterReactiveBle.scanForDevices(withServices: []).listen((newDevice) {
      devicesList.add(newDevice);
    });
    return devicesList;
  }
}
