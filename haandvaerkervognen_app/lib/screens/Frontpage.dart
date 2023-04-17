import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:haandvaerkervognen_app/popups/bluetoothPopup.dart';
import 'package:haandvaerkervognen_app/screens/SettingsPage.dart';
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
          actions: [
            IconButton(
                onPressed: goToSettings,
                icon: const Icon(
                  Icons.settings,
                  size: 35,
                ))
          ],
        ),
        body: FutureBuilder<String>(
          future: someFutureFunctionReturningString(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                //Make data widget
                return const Text('data was not empty');
              } else {
                return const CircularProgressIndicator();
              }
            }
            //Make pair widget
            return const Center(child: BluetoothPairButton());
          },
        ));
  }

  void goToSettings() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const SettingsPage())));
  }

  someFutureFunctionReturningString() {
    showDialog(
      context: context,
      builder: (context) => BluetoothPopup(),
    );
  }
}
