import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/firebase_options.dart';
import 'package:haandvaerkervognen_app/screens/Frontpage.dart';
import 'package:haandvaerkervognen_app/screens/Loginpage.dart';
import 'package:haandvaerkervognen_app/screens/RegisterPage.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haandvaerkernes Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Loginpage(),
    );
  }
}
