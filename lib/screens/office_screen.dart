import 'package:btec_security/data.dart';
import 'package:btec_security/employee/employee_screen.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btec_security/todos/todo_screen.dart';

class CardModel {
  final Widget icon;
  final String tiltle;
  const CardModel({this.icon, this.tiltle});
}

var cardData = <CardModel>[];

class OfficeScreen extends StatefulWidget {
  OfficeScreen({this.menu, this.user});
  final Menu menu;
  final FirebaseUser user;

  @override
  _OfficeScreenState createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _dateNow = new DateTime.now();
  String _date;
  int taskToday;

  @override
  void initState() {
    super.initState();
    cardData.clear();
    _date = '${_dateNow.day}-${_dateNow.month}-${_dateNow.year}';
    loadData();
  }

  Future loadData() async {
    cardData.add(CardModel(
        icon: LayoutBuilder(builder: (context, constraint) {
          return new Icon(
            Icons.people,
            size: constraint.biggest.height - 35,
            color: Colors.white,
          );
        }),
        tiltle: 'Employee'));
    cardData.add(CardModel(
        icon: LayoutBuilder(builder: (context, constraint) {
          return Container(
              child: new Icon(Icons.check,
                  size: constraint.biggest.height - 35, color: Colors.white));
        }),
        tiltle: 'Todo List'));
  }

  @override
  Widget build(BuildContext context) {
    Widget card(CardModel cardData, int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: InkWell(
          onTap: () async {
            if (index == 1) {
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
                'date': _date
              };
              taskToday = await getTaskToday(container);
            }

            Navigator.of(context).push(
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
                      if (index == 0) {
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        return Opacity(
                          opacity: animation.value,
                          child: EmployeeScreen(
                            user: widget.user,
                            menu: widget.menu,
                          ),
                        );
                      } else if (index == 1) {
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        return Opacity(
                          opacity: animation.value,
                          child: TodoScreen(
                              user: widget.user,
                              taskToday: taskToday),
                        );
                      }
                    },
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: CustomColors.front,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            cardData.tiltle,
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          child: cardData.icon,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1,
                      width: MediaQuery.of(context).size.width - 50,
                      child: Container(color: widget.menu.colors),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('VIEW',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: widget.menu.colors)),
                          Icon(Icons.arrow_right, color: widget.menu.colors)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
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
      body: Column(
        children: <Widget>[
          Container(
            color: widget.menu.colors,
            height: MediaQuery.of(context).size.height / 8,
          ),
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height / 3.8,
            child: ListView.builder(
              itemCount: cardData.length,
              itemBuilder: (context, index) {
                return card(cardData[index], index);
              },
            ),
          )
        ],
      ),
    );
  }
}
