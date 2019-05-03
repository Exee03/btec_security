import 'package:btec_security/data.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  MenuCard(this.index, this.menu);
  final int index;
  final Menu menu;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 30.0, left: 8.0, right: 8.0),
        child: Card(
          elevation: 5.0,
          color: menu.colors,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
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
                      Text(
                        menu.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
