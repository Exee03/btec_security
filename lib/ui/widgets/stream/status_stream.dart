import 'package:btec_security/models/model.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusStream extends StatefulWidget {
  final String uid;
  final String date;
  StatusStream({this.uid, this.date});

  @override
  _StatusStreamState createState() => _StatusStreamState();
}

class _StatusStreamState extends State<StatusStream> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('history')
          .document(widget.uid)
          .collection(widget.date)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              children: <Widget>[
                Text('no data'),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
        return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
            History history = History.fromMap(documentSnapshot);
            return ListTile(
              leading: Text(history.time, style: CustomFonts.logText),
              title: Text(history.title, style: CustomFonts.logText),
              subtitle: Text(history.detail, style: CustomFonts.logText),
            );
          },
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              height: 8.0,
              color: Colors.white,
            );
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
  }
}
