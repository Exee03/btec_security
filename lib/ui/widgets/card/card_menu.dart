import 'package:btec_security/data.dart';
import 'package:btec_security/screens/attendance_screen.dart';
import 'package:btec_security/screens/history_screen.dart';
import 'package:btec_security/screens/office_screen.dart';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard(this.index, this.menu, this.user);
  final int index;
  final Menu menu;
  final FirebaseUser user;
  int totalEmployee;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 30.0, left: 8.0, right: 8.0),
      child: InkWell(
        onTap: () async {
          if (index == 1) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Loading...',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
            totalEmployee = await getTotalEmployee(user.uid);
            Scaffold.of(context).hideCurrentSnackBar();
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
                      return Opacity(
                        opacity: animation.value,
                        child: OfficeScreen(
                          menu: menu,
                          user: user,
                        ),
                      );
                    } else if (index == 1) {
                      return Opacity(
                        opacity: animation.value,
                        child: AttendanceScreen(
                            menu: menu,
                            user: user,
                            totalEmployee: totalEmployee),
                      );
                    } else if (index == 2) {
                      return Opacity(
                        opacity: animation.value,
                        child: HistoryScreen(menu: menu, uid: user.uid),
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
          elevation: 5.0,
          color: menu.colors,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              width: 200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter,
                    stops: [0.1, 0.9],
                    colors: [
                      menu.colors,
                      Colors.white10,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image(
                            image: menu.image,
                            color: Colors.white,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Hero(
                        tag: menu.title,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            menu.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
