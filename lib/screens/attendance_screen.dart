import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/chart/attendance_chart.dart';
import 'package:btec_security/ui/widgets/table/attendance_table.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/rendering.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({this.menu, this.user, this.totalEmployee});
  final Menu menu;
  final FirebaseUser user;
  final int totalEmployee;
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime date = DateTime.now();
  String dateNow;

  @override
  void initState() {
    dateNow = '${date.day}-${date.month}-${date.year}';
    print(dateNow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.menu.colors,
        centerTitle: true,
        title: Hero(
          tag: widget.menu.title,
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.menu.title,
              style: CustomFonts.appBar,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('attendance')
              .document(widget.user.uid)
              .collection(dateNow)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
            return Column(
              children: <Widget>[
                Container(
                  color: widget.menu.colors,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                formatDate(date, ['DD']),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${date.day} / ${date.month} / ${date.year}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Employee : ${widget.totalEmployee}',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: new BoxDecoration(
                            color: Colors.white12,
                            shape: BoxShape.circle,
                          ),
                          child: snapshot.data.documents.isEmpty
                              ? AttendanceChart(
                                  total: 1.0,
                                  attendance:
                                      0.0,
                                )
                              : AttendanceChart(
                                  total: widget.totalEmployee.toDouble(),
                                  attendance:
                                      snapshot.data.documents.length.toDouble(),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: CustomColors.front,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Text(
                                  'Time',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: widget.menu.colors, fontSize: 18),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: widget.menu.colors, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Container(
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, index) {
                                  DocumentSnapshot data =
                                      snapshot.data.documents[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10),
                                    child: AttendanceTable(
                                      index: index,
                                      data: data,
                                      colors: widget.menu.colors,
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.documents.length,
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
