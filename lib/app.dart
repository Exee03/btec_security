import 'package:btec_security/models/message.dart';
import 'package:btec_security/screens/auth_screen.dart';
import 'package:btec_security/screens/home_screen.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AppRootWidget extends StatefulWidget {
  @override
  _AppRootWidgetState createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRootWidget> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // AppState appState;
  List<Message> messages = [];
  String _time = formatDate(DateTime.now(), [dd, '/', mm, ' - ', h, ':', nn, ' ', am]);
  
  ThemeData get _themeData => new ThemeData(
    primaryColor: Colors.orange,
    accentColor: Colors.amberAccent,
    scaffoldBackgroundColor: CustomColors.background,
    fontFamily: 'Open_Sans'
  );

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: '$_time\n${notification['body']}'));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        setState(() {
          messages.add(Message(
            title: 'onLaunch',
            body: '$message',
          ));
        });
        final notification = message['data'];
        setState(() {
          messages.add(Message(
              title: 'onLaunch : ${notification['title']}',
              body: 'onLaunch : ${notification['body']}'));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        final notification = message['data'];
        setState(() {
          messages.add(Message(
              title: 'onResume : ${notification['title']}',
              body: 'onResume : ${notification['body']}'));
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BTeC Security',
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      routes: {
        '/': (BuildContext context) => new HomeScreen(messages: messages),
        '/auth': (BuildContext context) => new AuthScreen(),
      },
    );
  }
}