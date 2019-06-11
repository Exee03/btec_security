import 'package:btec_security/utils/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeBranchAdd extends StatefulWidget {
  EmployeeBranchAdd({this.context, this.branch, this.user});
  final BuildContext context;
  final String branch;
  final FirebaseUser user;
  @override
  _EmployeeBranchAddState createState() => _EmployeeBranchAddState();
}

class _EmployeeBranchAddState extends State<EmployeeBranchAdd> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerCat = new TextEditingController();
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
        'branch': _controllerCat.text,
      };
      addBranch(container).catchError((onError) => _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adding new branch fail !\n$onError',
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.clip,
                ),
                Icon(Icons.error)
              ],
            ),
            backgroundColor: Colors.red,
          ),
        ));
        Navigator.pop(context);
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
          'New Branch',
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
                      'Where new branch are you want to add?',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 15),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30),
                          controller: _controllerCat,
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Branch'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter the Branch';
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
