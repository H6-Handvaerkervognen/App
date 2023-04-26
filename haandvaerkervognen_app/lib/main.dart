import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/firebase_options.dart';
import 'package:haandvaerkervognen_app/screens/Frontpage.dart';
import 'package:haandvaerkervognen_app/screens/Loginpage.dart';
import 'package:haandvaerkervognen_app/screens/RegisterPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseMessaging.instance.getInitialMessage();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Give context to foreground notifier, so we can show notifications in app
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundNotification(context, message));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haandvaerkernes Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Loginpage(),
    );
  }

  ///Method for handling an message appearing while the app is in the foreground
  onForegroundNotification(BuildContext context, RemoteMessage message) {
    print('On foreground notif called');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: ListTile(
            title: Text(message.notification!.title!),
            subtitle: Text(message.notification!.body!),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}
