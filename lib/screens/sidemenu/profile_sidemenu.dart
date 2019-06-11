import 'package:btec_security/auth/bloc.dart';
import 'package:btec_security/data.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  final Menu menu;
  final FirebaseUser user;
  final String company;
  Profile({this.menu, this.user, this.company});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String photoUrl;
  String name;
  @override
  void initState() {
    photoUrl = widget.user.photoUrl == null
        ? 'https://firebasestorage.googleapis.com/v0/b/btec-e4bef.appspot.com/o/blank-profile-picture-973460_640-300x300.png?alt=media&token=478ee3ec-7615-4966-ad1d-2220e798a0ee'
        : widget.user.photoUrl;
    name = widget.user.displayName == null
        ? widget.user.email
        : widget.user.displayName;
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
          Expanded(
            child: Card(
              margin: EdgeInsets.all(30),
              color: Theme.of(context).bottomAppBarColor,
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(photoUrl),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Text(
                        'Hi $name',
                        style: CustomFonts.invAppBar,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.company,
                        style: CustomFonts.invTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            child: RaisedButton(
              color: Colors.red[800],
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
                  .dispatch(LoggedOut()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign Out',
                    style: CustomFonts.invTextStyle,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
