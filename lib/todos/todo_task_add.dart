import 'package:btec_security/utils/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoTaskAddEdit extends StatefulWidget {
  TodoTaskAddEdit({
    this.context,
    this.todoCat,
    this.user,
    this.colors,
    this.currentDate,
    this.currentTitle,
    this.currentDetail,
  });
  final BuildContext context;
  final String todoCat;
  final FirebaseUser user;
  final Color colors;
  final String currentDate;
  final String currentTitle;
  final String currentDetail;
  @override
  _TodoTaskAddEditState createState() => _TodoTaskAddEditState();
}

class _TodoTaskAddEditState extends State<TodoTaskAddEdit> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerTitle = new TextEditingController();
  TextEditingController _controllerDetail = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  DateTime _dateNow = new DateTime.now();
  String _date;
  String _selectedDate;
  String _labelDate;

  Future _add() async {
    if (_formKey.currentState.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(
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
      print(widget.user.uid);
      print(widget.todoCat);
      print(_controllerTitle.text);
      print(_controllerDetail.text);
      print(_selectedDate);
      Map<String, String> container = {
        'uid': widget.user.uid,
        'todoCat': widget.todoCat,
        'title': _controllerTitle.text,
        'detail': _controllerDetail.text,
        'date': _selectedDate
      };
      if (widget.currentTitle == null) {
        print("widget.currentTitle == null");
        addTask(container);
      } else if (widget.currentTitle != null) {
        print("widget.currentTitle != null");
        editTask(container);
      }
    }
  }

  @override
  void initState() {
    _controllerDetail.text = widget.currentDetail;
    _controllerTitle.text = widget.currentTitle;
    _date = '${_dateNow.day}-${_dateNow.month}-${_dateNow.year}';
    _selectedDate = _date;
    widget.currentDate != null
        ? _labelDate = widget.currentDate
        : _labelDate = 'Today';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: widget.colors),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: widget.currentTitle == null
            ? Text(
                'New Task',
                style: TextStyle(color: widget.colors),
              )
            : Text(
                'Edit Task',
                style: TextStyle(color: widget.colors),
              ),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FloatingActionButton.extended(
            backgroundColor: widget.colors,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                _formKey.currentState.save();
                await _add().then((_) => Navigator.pop(context));
              }
            },
            label: Icon(Icons.add),
            elevation: 5.0,
          ),
        ),
      ),
      body: new Theme(
        data: new ThemeData(
          hintColor: Colors.white30,
          cursorColor: widget.colors,
          primaryColor: widget.colors,
        ),
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'What tasks are you planning to perform?',
                      style: TextStyle(color: widget.colors, fontSize: 15),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(color: widget.colors, fontSize: 30),
                          controller: _controllerTitle,
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Title'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter Title of Task';
                            }
                          }),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        style: TextStyle(color: widget.colors),
                        cursorColor: Colors.white,
                        controller: _controllerDetail,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Details",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      child: ListTile(
                        leading: Icon(Icons.date_range, color: widget.colors),
                        title: _labelDate == _date
                            ? Text(
                                'Today',
                                style: TextStyle(color: widget.colors),
                              )
                            : Text(
                                _labelDate,
                                style: TextStyle(color: widget.colors),
                              ),
                      ),
                      onPressed: () async {
                        final DateTime picked = await showDatePicker(
                          context: context,
                          firstDate: new DateTime(2018),
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
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
