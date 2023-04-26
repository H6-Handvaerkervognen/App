import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/screens/AlarmPage.dart';
import 'package:haandvaerkervognen_app/screens/Loginpage.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:haandvaerkervognen_app/services/TokenService.dart';
import 'package:haandvaerkervognen_app/widgets/BluetoothPairButton.dart';

///Page that has overview of every alarm currently connected.
///Ability to pair more with bluetooth or navigate to each alarm's page.
///Also able to logout from here
class Frontpage extends StatefulWidget {
  const Frontpage({super.key, required this.username, required this.http});

  final String username;
  final HttpService http;

  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> {
  late List<Alarm> alarms;
  late TokenService _tokenService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Oversigt', style: TextStyle(fontSize: 30)),
      ),
      body: FutureBuilder<List<Alarm>>(
        //If the () are there, the method is run immediately
        future: getAlarms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Text('There was an error ${snapshot.error}');
          }
          if (snapshot.hasData) {
            List<Alarm> fetchedAlarms = snapshot.data as List<Alarm>;
            alarms = fetchedAlarms;
            if (alarms.isEmpty) {
              return Center(
                  child: BluetoothPairButton(
                      minWidth: 200,
                      minHeight: 55,
                      maxWidth: 275,
                      maxHeight: 60,
                      fontSize: 30));
            }
            return Center(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      //Generate elements from the snapshot
                      children: List.generate(
                        alarms.length,
                        (index) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    0.15 * MediaQuery.of(context).size.width),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        goToAlarmPage(alarms[index]),
                                    child: Text(alarms[index].iD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  BluetoothPairButton(
                      minWidth: 220,
                      minHeight: 40,
                      maxWidth: 260,
                      maxHeight: 50,
                      fontSize: 15)
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      //Floating logout button
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 2, 16),
        child: FloatingActionButton(
          onPressed: () => logOut(),
          splashColor: Colors.blue[300],
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.logout_outlined,
          ),
        ),
      ),
    );
  }

  ///Fetches alarms from the api related to this user
  Future<List<Alarm>> getAlarms() async {
    //Add username
    List<Alarm> alarms = await widget.http.getAlarms(widget.username);

    if (alarms.isNotEmpty) {
      subscribeToAlarms(alarms);
      return alarms;
    }

    List<Alarm> testAlarms = [
      Alarm(
          iD: 'isda1',
          startTime: TimeOfDay.now(),
          endTime: TimeOfDay.now(),
          name: 'Carstens bil'),
      Alarm(
          iD: 'Alarm 2',
          startTime: TimeOfDay.now(),
          endTime: TimeOfDay.now(),
          name: 'Jespers bil'),
    ];
    //Test topic always subscribed to.
    FirebaseMessaging.instance.subscribeToTopic('Test');
    return testAlarms;
  }

  ///Logout method
  void logOut() async {
    //print(await FirebaseMessaging.instance.getToken());
    //FirebaseMessaging.instance.subscribeToTopic('Test');
    _tokenService = TokenService();
    _tokenService.dropToken();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const Loginpage()));
  }

  ///Navigates to a specified alarm
  goToAlarmPage(Alarm alarm) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlarmPage(
                  http: widget.http,
                  alarm: alarm,
                )));
  }

  ///Loops through all alarms and subscribes to their unique topics
  void subscribeToAlarms(List<Alarm> alarms) {
    for (int i = 0; i < alarms.length; i++) {
      FirebaseMessaging.instance.subscribeToTopic(alarms[i].iD);
      print('Subscribed to topic: ${alarms[i].iD}');
    }
  }
}
