import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BluetoothPairButton extends StatelessWidget {
  const BluetoothPairButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: startBlueTooth,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        minimumSize: const Size(200, 55),
        maximumSize: const Size(275, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.bluetooth, size: 40),
          Spacer(flex: 1),
          Text('Par en alarm', style: TextStyle(fontSize: 30)),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  startBlueTooth() {}
}
