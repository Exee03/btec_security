import 'package:flutter/material.dart';

class OfficeScreen extends StatefulWidget {
  @override
  _OfficeScreenState createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('data', style: TextStyle(color: Colors.white70, fontSize: 20.0)),
            ],
          )
        ],
      ),
    );
  }
}
