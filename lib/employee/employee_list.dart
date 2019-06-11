import 'package:btec_security/employee/employee_add_edit.dart';
import 'package:btec_security/employee/employee_detail.dart';
import 'package:btec_security/models/model.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  EmployeeList({this.context, this.branch, this.user, this.colors});
  final BuildContext context;
  final String branch;
  final FirebaseUser user;
  final Color colors;
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: widget.colors),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Hero(
        tag: widget.branch,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Text(
                widget.branch,
                style: TextStyle(color: widget.colors, fontSize: 30),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('employee')
                        .document(widget.user.uid)
                        .collection(widget.branch)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data.documentChanges.isEmpty ||
                          snapshot.data.documents[0].data['name'] == 'null') {
                        return AlertDialog(
                          backgroundColor: Theme.of(context).bottomAppBarColor,
                          title: Text('No Employee',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor)),
                          content: Container(
                            height: 250,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'You want to add new Employee?',
                                  style: CustomFonts.invTextStyle,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            RaisedButton(
                              color: Colors.white30,
                              child: Text('Yes'),
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
                                                  colors: widget.colors,
                                                  branch: widget.branch),
                                            );
                                          },
                                        );
                                      },
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                    ),
                                  ),
                            ),
                            RaisedButton(
                                color: Colors.white30,
                                child: Text('No'),
                                onPressed: () => Navigator.pop(context))
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Container(
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data.documents[index];
                                Employee employee =
                                    Employee.fromMap(documentSnapshot, index);
                                    print(employee.profileUrl);
                                return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                        PageRouteBuilder<Null>(
                                          pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
                                          ) {
                                            return AnimatedBuilder(
                                              animation: animation,
                                              builder: (
                                                BuildContext context,
                                                Widget child,
                                              ) {
                                                return Opacity(
                                                  opacity: animation.value,
                                                  child: EmployeeDetail(
                                                    context: context,
                                                    user: widget.user,
                                                    branch: widget.branch,
                                                    colors: widget.colors,
                                                    employee: employee,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                        ),
                                      ),
                                  child: Dismissible(
                                    key: Key(employee.name),
                                    onDismissed: (direction) async {
                                      _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Loading...',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              CircularProgressIndicator(),
                                            ],
                                          ),
                                        ),
                                      );
                                      Map<String, String> container = {
                                        'uid': widget.user.uid,
                                        'branch': widget.branch,
                                        'name': employee.name,
                                      };
                                      if (snapshot.data.documents.length == 1) {
                                        await deleteEmployee(container);
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                          "${employee.name} is deleted!",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )));
                                        Navigator.of(context);
                                      } else {
                                        await deleteEmployee(container);
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                          "${employee.name} is deleted!",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )));
                                      }
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      child: Center(child: Text('Delete!')),
                                    ),
                                    child: Card(
                                      color: widget.colors,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    employee.profileUrl)),
                                        title: Text(employee.name),
                                        subtitle: Text(employee.level),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data.documents.length,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.colors,
        child: Icon(Icons.add),
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
                            colors: widget.colors,
                            branch: widget.branch),
                      );
                    },
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
              ),
            ),
      ),
    );
  }
}
