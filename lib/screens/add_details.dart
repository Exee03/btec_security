import 'dart:async';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailsEvent extends StatefulWidget {
  final BuildContext context;
  final FirebaseUser user;
  final String time;
  final String date;
  final String titleOld;
  DetailsEvent({
    this.context,
    this.user,
    this.time,
    this.date,
    this.titleOld,
  });
  @override
  _DetailsEventState createState() => _DetailsEventState();
}

class _DetailsEventState extends State<DetailsEvent> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerDetail = new TextEditingController();

  Future _add(context) async {
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
      print(widget.time);

      Map<String, String> container = {
        'uid': widget.user.uid,
        'time': widget.time,
        'date': widget.date,
        'title': _controllerName.text,
        'detail': _controllerDetail.text,
      };
      addDetailsEvent(container);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Details of event',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                _formKey.currentState.save();

                await _add(context)
                    .then(
                        (_) => Navigator.of(context, rootNavigator: true)..pop())
                    .catchError((onError) => _scaffoldKey.currentState
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Adding details of event fail !\n$onError',
                                style: TextStyle(
                                    color: Colors.black),
                                overflow: TextOverflow.clip,
                              ),
                              Icon(Icons.error)
                            ],
                          ),
                          backgroundColor: Colors.red,
                        ),
                      ));
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
          cursorColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).primaryColor,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Text(
                                'What happen? Please give the details...',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Title',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                          controller: _controllerName,
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Title'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter Title of event';
                            }
                          }),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Details',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20),
                          controller: _controllerDetail,
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true,
                              hintText: 'Details'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter Details of event';
                            }
                          }),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
