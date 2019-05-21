import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/chart/attendance_chart.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardModel {
  final Widget icon;
  final String tiltle;
  const CardModel({this.icon, this.tiltle});
}

var cardData = <CardModel>[];

class OfficeScreen extends StatefulWidget {
  OfficeScreen({this.menu});
  final Menu menu;
  @override
  _OfficeScreenState createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  @override
  void initState() {
    super.initState();
    cardData.clear();
    loadData();
  }

  Future loadData() async {
    print(cardData.length);
    cardData.add(CardModel(icon: AttendanceChart(), tiltle: 'Attendance'));
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
    print(cardData.length);
  }

  @override
  Widget build(BuildContext context) {
    Widget card(CardModel cardData) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: <Widget>[],
                  //   ),
                  // ),
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.menu.colors,
        centerTitle: true,
        title: Text(
          widget.menu.title,
          style: CustomFonts.appBar,
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
                return card(cardData[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
