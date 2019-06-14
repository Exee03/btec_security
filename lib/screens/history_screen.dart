import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/stream/status_stream.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({this.menu, this.uid});
  final Menu menu;
  final String uid;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: ListTile(
                    leading: Icon(Icons.date_range, color: Colors.white),
                    title: _labelDate == _date
                        ? Text(
                            'Today',
                            style: CustomFonts.invTextStyle,
                          )
                        : Text(
                            _labelDate,
                            style: CustomFonts.invTextStyle
                          ),
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: StatusStream(
                date: _selectedDate,
                uid: widget.uid,
              ),
            ),
          )
        ],
      ),
    );
  }
}
