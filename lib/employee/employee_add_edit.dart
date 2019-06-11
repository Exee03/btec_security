import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:btec_security/models/model.dart';
import 'package:btec_security/utils/firebase_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EmployeeAddEdit extends StatefulWidget {
  final BuildContext context;
  final FirebaseUser user;
  final String branch;
  final Employee employee;
  final Color colors;
  final String currentProfilePic;
  EmployeeAddEdit({
    this.context,
    this.user,
    this.branch,
    this.employee,
    this.colors,
    this.currentProfilePic,
  });
  @override
  _EmployeeAddEditState createState() => _EmployeeAddEditState();
}

class _EmployeeAddEditState extends State<EmployeeAddEdit> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerLevel = new TextEditingController();
  TextEditingController _controllerSalary = new TextEditingController();
  String _controllerProfilePic;
  File image;
  String fileName;

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
      print(widget.user.uid);
      print(_controllerName.text);
      print(_controllerLevel.text);
      print(_controllerSalary.toString());

      if (widget.employee == null) {
        Map<String, String> container = {
          'uid': widget.user.uid,
          'branch': widget.branch,
          'profileUrl': _controllerProfilePic,
          'name': _controllerName.text,
          'level': _controllerLevel.text,
          'salary': _controllerSalary.text.toString(),
        };
        print("widget.currentName == null");
        addEmployee(container);
      } else if (widget.employee.name != null) {
        Map<String, String> container = {
          'uid': widget.user.uid,
          'branch': widget.branch,
          'previousName': widget.employee.name,
          'profileUrl': _controllerProfilePic,
          'name': _controllerName.text,
          'level': _controllerLevel.text,
          'salary': _controllerSalary.text.toString(),
        };
        print("widget.currentName != null");
        editEmployee(container);
      }
    }
  }

  Future _addProfilePic(context) async {
    var _selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = _selectedImage;
      fileName = basename(image.path);
    });
    await uplaodImage(context);
  }

  Future<String> uplaodImage(context) async {
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
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    print('Download url : $url');

    setState(() {
      _controllerProfilePic = url;
    });

    return url;
  }

  @override
  void initState() {
    if (widget.employee != null) {
      _controllerName.text = widget.employee.name;
      _controllerLevel.text = widget.employee.level;
      widget.employee.salary == null
          ? _controllerSalary.text = null
          : _controllerSalary.text = widget.employee.salary.toString();
    }
    _controllerProfilePic = widget.currentProfilePic == null
        ? 'https://firebasestorage.googleapis.com/v0/b/btec-e4bef.appspot.com/o/blank-profile-picture-973460_640-300x300.png?alt=media&token=478ee3ec-7615-4966-ad1d-2220e798a0ee'
        : widget.currentProfilePic;
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
        title: widget.employee == null
            ? Text(
                'Add Employee Profile',
                style: TextStyle(color: widget.colors),
              )
            : Text(
                'Edit Employee Profile',
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
                if (widget.employee == null) {
                  await _add(context)
                      .then((_) => Navigator.pop(context))
                      .catchError((onError) => _scaffoldKey.currentState
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Adding new employee fail !\n$onError',
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
                } else if (widget.employee.name != null) {
                  await _add(context)
                      .then((_) => Navigator.pop(context))
                      .then((_) => Navigator.pop(context))
                      .catchError((onError) => _scaffoldKey.currentState
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Adding new employee fail !\n$onError',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  overflow: TextOverflow.clip,
                                ),
                                Icon(Icons.error)
                              ],
                            ),
                            backgroundColor: Colors.red,
                          ),
                        ));
                }
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () => _addProfilePic(context),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            CachedNetworkImageProvider(_controllerProfilePic),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Name',
                              style: TextStyle(
                                  color: widget.colors, fontSize: 15)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(color: widget.colors),
                          controller: _controllerName,
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Name'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter Name of employee';
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
                          Text('Level',
                              style: TextStyle(
                                  color: widget.colors, fontSize: 15)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(color: widget.colors, fontSize: 20),
                          controller: _controllerLevel,
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Level'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter Level of employee';
                            }
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Salary',
                              style: TextStyle(
                                  color: widget.colors, fontSize: 15)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                          style: TextStyle(color: widget.colors, fontSize: 20),
                          controller: _controllerSalary,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: new InputDecoration.collapsed(
                              hasFloatingPlaceholder: true, hintText: 'Salary'),
                          validator: (val) {
                            if (val.length < 1) {
                              return 'Please enter Salary of employee';
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
