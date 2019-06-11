import 'package:btec_security/models/model.dart';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeRating extends StatefulWidget {
  EmployeeRating(
      {this.context, this.branch, this.user, this.colors, this.employee});
  final BuildContext context;
  final String branch;
  final FirebaseUser user;
  final Color colors;
  final Employee employee;

  @override
  _EmployeeRatingState createState() => _EmployeeRatingState();
}

class _EmployeeRatingState extends State<EmployeeRating> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerRating = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();

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
      Map<String, String> container = {
        'uid': widget.user.uid,
        'ratingDetail': _controllerRating.text,
        'branch': widget.branch,
        'name': widget.employee.name
      };
      ratingEmployee(container).then((_) => Navigator.pop(context));
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
          'New Rating',
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
              await _add();
              Navigator.pop(context);
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
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'What a point to rating him/her?',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 15),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: TextFormField(
                          controller: _controllerRating,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30),
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Rating'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter the rating';
                            }
                          }),
                    ),
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
