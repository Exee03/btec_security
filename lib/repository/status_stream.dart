import 'package:btec_security/models/model.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusStream extends StatefulWidget {
  final String uid;
  StatusStream({this.uid});

  @override
  _StatusStreamState createState() => _StatusStreamState();
}

class _StatusStreamState extends State<StatusStream> {
  String dateNow =
      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('status')
          .document(widget.uid)
          .collection(dateNow)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
            Status status = Status.fromMap(documentSnapshot);
            return ListTile(
              leading: Text(status.time, style: CustomFonts.logText),
              title: Text(status.status, style: CustomFonts.logText),
              subtitle: Text(status.detail, style: CustomFonts.logText),
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
