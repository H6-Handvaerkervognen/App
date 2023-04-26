import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  //For android, you cannot make heads up foreground notifications,
  //Unless the channel they are sent on are max importance, so we create a new channel instance
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  //Create a new channel (if a channel with an id already exists, it will be updated)
  //After we set up the channel in the androidmanifest.xml So FCM will use this channel instead of the default one.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //Needed to make heads up foreground notifications on IOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Give context to foreground notifier, so we can show notifications in app

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haandvaerkernes Alarm',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Loginpage(),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}
