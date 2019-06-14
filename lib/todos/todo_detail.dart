import 'package:btec_security/models/model.dart';
import 'package:btec_security/todos/todo_task_add.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TodoDetail extends StatefulWidget {
  TodoDetail({this.context, this.todoCat, this.user, this.colors});
  final BuildContext context;
  final String todoCat;
  final FirebaseUser user;
  final Color colors;
  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int sharedValue = 0;

  final Map<int, Widget> widgetTodo = const <int, Widget>{
    0: Text('Incomplete'),
    1: Text('Completed'),
  };

  @override
  Widget build(BuildContext context) {
    alertDialogs() {
      return AlertDialog(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        title: Text('No Task',
            style:
                TextStyle(fontSize: 20, color: Theme.of(context).primaryColor)),
        content: Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Text(
                'You want to add new Task?',
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
                            child: TodoTaskAddEdit(
                                context: context,
                                todoCat: widget.todoCat,
                                user: widget.user,
                                colors: widget.colors),
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
    }

    final Map<int, Widget> widgets = <int, Widget>{
      0: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('todo')
              .document(widget.user.uid)
              .collection(widget.todoCat)
              .where('complete', isEqualTo: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.documentChanges.isEmpty) {
              return alertDialogs();
            } else if (snapshot.data.documents.length == 0) {
              if (snapshot.data.documents[0].data['title'] == 'null') {
                return alertDialogs();
              }
              return alertDialogs();
            } else if (snapshot.data.documentChanges.isNotEmpty) {
              return Container(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.documents[index];
                    Todos todo = Todos.fromMap(documentSnapshot, index);
                    return Dismissible(
                      key: Key(todo.title),
                      onDismissed: (direction) async {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                        Map<String, String> container = {
                          'uid': widget.user.uid,
                          'title': todo.title,
                          'todoCat': widget.todoCat,
                          'date': todo.date,
                          'complete': 'true'
                        };
                        doneTask(container);
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                          "Task of ( ${todo.title} ) is accomplish!",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        )));
                        if (snapshot.data.documents.length == 1) {
                          Navigator.pop(context);
                        }
                      },
                      background: Container(
                        color: Colors.green,
                        child: Center(child: Text('')),
                      ),
                      child: InkWell(
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
                                      return Opacity(
                                        opacity: animation.value,
                                        child: TodoTaskAddEdit(
                                          context: context,
                                          todoCat: widget.todoCat,
                                          user: widget.user,
                                          colors: widget.colors,
                                          currentDate: todo.date,
                                          currentTitle: todo.title,
                                          currentDetail: todo.detail,
                                        ),
                                      );
                                    },
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 500),
                              ),
                            ),
                        child: ListTile(
                          leading: Text(todo.date, style: CustomFonts.logText),
                          title: Text(todo.title, style: CustomFonts.logText),
                          subtitle:
                              Text(todo.detail, style: CustomFonts.logText),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return Divider(
                      height: 8.0,
                      color: Colors.white,
                    );
                  },
                  itemCount: snapshot.data.documents.length,
                ),
              );
            }
          },
        ),
      ),
      1: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('todo')
              .document(widget.user.uid)
              .collection(widget.todoCat)
              .where('complete', isEqualTo: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              child: ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data.documents[index];
                  Todos todo = Todos.fromMap(documentSnapshot, index);
                  return Dismissible(
                    key: Key(todo.title),
                    onDismissed: (direction) async {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Loading...',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor),
                              ),
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      );
                      Map<String, String> container = {
                        'uid': widget.user.uid,
                        'title': todo.title,
                        'todoCat': widget.todoCat,
                        'date': todo.date,
                        'complete': 'false'
                      };
                      doneTask(container);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                        "Task of ( ${todo.title} ) is add back!",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      )));
                    },
                    background: Container(
                      color: Colors.red,
                      child: Center(child: Text('Add back!')),
                    ),
                    child: InkWell(
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
                                    return Opacity(
                                      opacity: animation.value,
                                      child: TodoTaskAddEdit(
                                        context: context,
                                        todoCat: widget.todoCat,
                                        user: widget.user,
                                        colors: widget.colors,
                                        currentDate: todo.date,
                                        currentTitle: todo.title,
                                        currentDetail: todo.detail,
                                      ),
                                    );
                                  },
                                );
                              },
                              transitionDuration: Duration(milliseconds: 500),
                            ),
                          ),
                      child: ListTile(
                        leading: Text(todo.date, style: CustomFonts.logText),
                        title: Text(todo.title, style: CustomFonts.logText),
                        subtitle: Text(todo.detail, style: CustomFonts.logText),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, index) {
                  return Divider(
                    height: 8.0,
                    color: Colors.white,
                  );
                },
                itemCount: snapshot.data.documents.length,
              ),
            );
          },
        ),
      ),
    };

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Loading...',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
              Map<String, String> container = {
                'uid': widget.user.uid,
                'branch': widget.todoCat,
              };
              deleteCat(container);
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(
                "${widget.todoCat} category is deleted!",
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              )));
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
        iconTheme: IconThemeData(color: widget.colors),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Hero(
        tag: widget.todoCat,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text(
                    widget.todoCat,
                    style: TextStyle(color: widget.colors, fontSize: 30),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: CupertinoSegmentedControl<int>(
                  selectedColor: widget.colors,
                  borderColor: widget.colors,
                  unselectedColor: Theme.of(context).scaffoldBackgroundColor,
                  pressedColor: Colors.white,
                  children: widgetTodo,
                  onValueChanged: (int val) {
                    setState(() {
                      sharedValue = val;
                    });
                  },
                  groupValue: sharedValue,
                ),
              ),
              Expanded(
                flex: 2,
                child: widgets[sharedValue],
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
                        child: TodoTaskAddEdit(
                            context: context,
                            todoCat: widget.todoCat,
                            user: widget.user,
                            colors: widget.colors),
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
