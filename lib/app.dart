import 'package:btec_security/screens/auth_screen.dart';
import 'package:btec_security/screens/home_screen.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class AppRootWidget extends StatefulWidget {
  @override
  _AppRootWidgetState createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
    primaryColor: Colors.orange,
    accentColor: Colors.amberAccent,
    scaffoldBackgroundColor: CustomColors.background,
    fontFamily: 'Open_Sans'
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BTeC Security',
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      routes: {
        '/': (BuildContext context) => new HomeScreen(),
        '/auth': (BuildContext context) => new AuthScreen(),
      },
    );
  }
}