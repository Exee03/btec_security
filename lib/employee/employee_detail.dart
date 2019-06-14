import 'package:btec_security/employee/employee_add_edit.dart';
import 'package:btec_security/employee/employee_rating.dart';
import 'package:btec_security/models/model.dart';
import 'package:btec_security/ui/widgets/chart/attendance_chart.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EmployeeDetail extends StatefulWidget {
  EmployeeDetail(
      {this.context, this.branch, this.user, this.colors, this.employee});
  final BuildContext context;
  final String branch;
  final FirebaseUser user;
  final Color colors;
  final Employee employee;
  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  double _rating;
  int no;
  String profilePic;

  @override
  void initState() {
    _rating = widget.employee.rating;
    profilePic = widget.employee.profileUrl == null
        ? 'https://firebasestorage.googleapis.com/v0/b/btec-e4bef.appspot.com/o/blank-profile-picture-973460_640-300x300.png?alt=media&token=478ee3ec-7615-4966-ad1d-2220e798a0ee'
        : widget.employee.profileUrl;
    no = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
                  PageRouteBuilder<Null>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (
                          BuildContext context,
                          Widget child,
                        ) {
                          return Opacity(
                            opacity: animation.value,
                            child: EmployeeAddEdit(
                              context: context,
                              user: widget.user,
                              employee: widget.employee,
                              colors: widget.colors,
                              currentProfilePic: profilePic,
                              branch: widget.branch,
                            ),
                          );
                        },
                      );
                    },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                ),
          )
        ],
        backgroundColor: widget.colors,
        centerTitle: true,
        title: Text(
          widget.branch,
          style: CustomFonts.appBar,
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.colors,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmployeeRating(
                    context: context,
                    branch: widget.branch,
                    user: widget.user,
                    employee: widget.employee,
                    colors: widget.colors)),
          );
          // Navigator.of(context).push(
          //   PageRouteBuilder<Null>(
          //     pageBuilder: (
          //       BuildContext context,
          //       Animation<double> animation,
          //       Animation<double> secondaryAnimation,
          //     ) {
          //       return AnimatedBuilder(
          //         animation: animation,
          //         builder: (
          //           BuildContext context,
          //           Widget child,
          //         ) {
          //           return Opacity(
          //             opacity: animation.value,
          //             child: EmployeeRating(
          //                 context: context,
          //                 branch: widget.branch,
          //                 user: widget.user,
          //                 employee: widget.employee,
          //                 colors: widget.colors),
          //           );
          //         },
          //       );
          //     },
          //     transitionDuration: Duration(milliseconds: 500),
          //   ),
          // );
          print(result);
          setState(() {
            _rating = _rating + double.parse(result);
          });
        },
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: widget.colors,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          widget.employee.name,
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          widget.employee.level,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(profilePic),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Attendance',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: widget.colors,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: new BoxDecoration(
                                  color: Colors.white12,
                                  shape: BoxShape.circle,
                                ),
                                child: AttendanceChart(
                                    attendance:
                                        widget.employee.attendance.toDouble(),
                                    total: 40),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Salary',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: widget.colors,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                decoration: new BoxDecoration(
                                  color: Colors.white12,
                                  shape: BoxShape.rectangle,
                                ),
                                child: Center(
                                    child: Text(
                                  'RM ' +
                                      widget.employee.salary.toString() +
                                      '.00',
                                  style: TextStyle(color: widget.colors),
                                )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Performance',
                      style: TextStyle(
                          fontSize: 20,
                          color: widget.colors,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white12,
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            FlutterRatingBarIndicator(
                              rating: _rating,
                              itemCount: 5,
                              itemSize: 30.0,
                              emptyColor: Colors.amber.withAlpha(50),
                            ),
                            Expanded(
                              child: Container(
                                child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('employee')
                                        .document(widget.user.uid)
                                        .collection(widget.branch)
                                        .where('name',
                                            isEqualTo: widget.employee.name)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      DocumentSnapshot documentSnapshot =
                                          snapshot.data.documents[0];
                                      List<dynamic> employees =
                                          documentSnapshot['ratingDetail'];
                                      if (employees == null) {
                                        return Center(
                                          child: Text('No Rating',
                                              style: TextStyle(
                                                  color: widget.colors,
                                                  fontSize: 15)),
                                        );
                                      }
                                      return ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          no = index + 1;
                                          return ListTile(
                                            leading: Text(no.toString(),
                                                overflow: TextOverflow.clip,
                                                style:
                                                    CustomFonts.invTextStyle),
                                            title: Text(
                                              employees[index],
                                              style: CustomFonts.invTextStyle,
                                            ),
                                          );
                                        },
                                        itemCount: employees.length,
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
