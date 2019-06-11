import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/stream/status_stream.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/material.dart';

class HistoryScreenSidemenu extends StatefulWidget {
  HistoryScreenSidemenu({this.menu, this.uid});
  final Menu menu;
  final String uid;
  @override
  _HistoryScreenSidemenuState createState() => _HistoryScreenSidemenuState();
}

class _HistoryScreenSidemenuState extends State<HistoryScreenSidemenu> {
  DateTime _dateNow = new DateTime.now();
  String _date;
  String _selectedDate;
  String _labelDate;

  @override
  void initState() {
    _date = '${_dateNow.day}-${_dateNow.month}-${_dateNow.year}';
    _selectedDate = _date;
    _labelDate = 'Today';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).bottomAppBarColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 8.5,
            child: Center(
              child: Text(
                widget.menu.title,
                style: TextStyle(
                  fontSize: 35,
                  color: widget.menu.colors,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
            child: Container(color: widget.menu.colors),
          ),
          MaterialButton(
            child: ListTile(
              leading: Icon(Icons.date_range, color: Colors.white),
              title: _labelDate == _date
                  ? Text(
                      'Today',
                      style: CustomFonts.invTextStyle,
                    )
                  : Text(_labelDate, style: CustomFonts.invTextStyle),
            ),
            onPressed: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                firstDate: new DateTime(2019),
                initialDate: _dateNow,
                lastDate: new DateTime(2025),
              );
              if (picked != null && picked != _dateNow) {
                setState(() {
                  _selectedDate =
                      '${picked.day}-${picked.month}-${picked.year}';
                  if (_selectedDate == _date) {
                    _labelDate = 'Today';
                  } else {
                    _labelDate = _selectedDate;
                  }
                });
              }
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: StatusStream(
                date: _labelDate,
                uid: widget.uid,
              ),
            ),
          )
        ],
      ),
    );
  }
}
