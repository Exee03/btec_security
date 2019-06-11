import 'dart:async';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendSms extends StatefulWidget {
  final String uid;
  SendSms({this.uid});
  @override
  _SendSmsState createState() => new _SendSmsState();
}

class _SendSmsState extends State<SendSms> {

  Future<Null> sendingSms() async {
    print("SendSMS");
    try {
      final String result = await sendSms(widget.uid);
      print(result);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Report it to Police?\nChoose the method to report.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: new Container(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: new FlatButton(
                          color: Colors.white30,
                          onPressed: () => sendingSms(),
                          child: const Text("Send SMS")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: new FlatButton(
                          color: Colors.white30,
                          onPressed: () => _launchURL(),
                          child: const Text("Call")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: new FlatButton(
                          color: Colors.red[800],
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'tel:999';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
