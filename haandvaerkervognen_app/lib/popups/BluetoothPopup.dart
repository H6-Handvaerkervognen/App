import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class BluetoothPopup extends StatefulWidget {
  const BluetoothPopup({super.key});

  @override
  State<BluetoothPopup> createState() => _BluetoothPopupState();
}

class _BluetoothPopupState extends State<BluetoothPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        const Text('Titel mester'),
        FutureBuilder<List<String>>(
          future: findBluetoothDevices(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<String> strings = snapshot.data as List<String>;

              return ListView.builder(
                  itemCount: strings.length,
                  itemBuilder: (context, index) {
                    Text(strings[index]);
                  });
            }
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  findBluetoothDevices() {}
}
