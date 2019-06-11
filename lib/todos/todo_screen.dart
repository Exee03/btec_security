import 'package:btec_security/todos/todo_cat_add.dart';
import 'package:btec_security/todos/todo_detail.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({this.user, this.taskToday});
  final FirebaseUser user;
  final int taskToday;
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  CustomRandomColor customColor = new CustomRandomColor();
  int idColor;
  String displayName;
  int lengthItem;
  int lengthItemAdd;
  DateTime _dateNow = new DateTime.now();
  String _date;

  @override
  void initState() {
    idColor = 0;
    _date = '${_dateNow.day}-${_dateNow.month}-${_dateNow.year}';
    super.initState();
  }

  @override
  void didUpdateWidget(TodoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget todoCard(BuildContext context, String todoCat, Color colors) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
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
                    if (todoCat == 'Add') {
                      return Opacity(
                        opacity: animation.value,
                        child: TodoCatAdd(
                            context: context,
                            user: widget.user),
                      );
                    }
                    return Opacity(
                      opacity: animation.value,
                      child: TodoDetail(
                        context: context,
                        todoCat: todoCat,
                        user: widget.user,
                        colors: customColor.next(idColor),
                      ),
                    );
                  },
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: todoCat,
          child: Card(
            elevation: 5.0,
            color: todoCat == 'Add'
                ? CustomColors.front
                : Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Align(
                alignment: Alignment.center,
                child: Text(todoCat,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors, fontSize: 30))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    if (widget.user.displayName == null) {
      displayName = widget.user.email;
    } else {
      displayName = widget.user.displayName;
    }
    return Scaffold(
      backgroundColor: customColor.next(idColor),
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('todo')
              .where('uid', isEqualTo: widget.user.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data.documents.isEmpty) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).bottomAppBarColor,
                  title: Text('No Category',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor)),
                  content: Container(
                    height: 250,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'You want to add new Category of Todo?',
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
                                      child: TodoCatAdd(
                                        context: context,
                                        user: widget.user,
                                      ),
                                    );
                                  },
                                );
                              },
                              transitionDuration: Duration(milliseconds: 500),
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
                Map<String, dynamic> documentSnapshot =
                    snapshot.data.documents[0].data;
                List<dynamic> todoCat = documentSnapshot['collections'];
                lengthItem = todoCat.length;
                lengthItemAdd = todoCat.length + 1;
                return Container(
                  width: screen.width,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                              'Hello $displayName',
                              style: TextStyle(fontSize: 25),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                  'You have ${widget.taskToday.toString()} tasks to do today.'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text('Today : $_date'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: screen.width,
                          child: Swiper(
                            itemCount: lengthItemAdd,
                            viewportFraction: 0.8,
                            scale: 1,
                            loop: false,
                            onIndexChanged: (int index) {
                              setState(() {
                                idColor = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              if (index >= lengthItem) {
                                return todoCard(
                                    context, "Add", customColor.next(idColor));
                              }
                              return todoCard(context, todoCat[index],
                                  customColor.next(idColor));
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              }
            }
          }),
    );
  }
}
