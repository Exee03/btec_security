import 'package:btec_security/data.dart';
import 'package:btec_security/repository/status_stream.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({this.menu, this.uid});
  final Menu menu;
  final String uid;
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
          Container(
            color: widget.menu.colors,
            height: MediaQuery.of(context).size.height / 8,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: StatusStream(
                uid: widget.uid,
              ),
            ),
          )
        ],
      ),
    );
  }
}
