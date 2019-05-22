import 'package:btec_security/data.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({this.menu});
  final Menu menu;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.menu.colors,
        centerTitle: true,
        title: Text(
          widget.menu.title,
          style: CustomFonts.appBar,
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('asdsd',
                  style: TextStyle(color: Colors.white70, fontSize: 20.0)),
            ],
          )
        ],
      ),
    );
  }
}
