import 'package:flutter/material.dart';

class Unauthorised extends StatefulWidget {
  Unauthorised({this.email});
  final String email;
  @override
  _UnauthorisedState createState() => _UnauthorisedState();
}

class _UnauthorisedState extends State<Unauthorised> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.error, size: 50,),
              SizedBox(height: 20,width: 20,),
              Text('Error!',style: TextStyle(fontSize: 30),)
            ],
          ),
          content: Container(
              child: Text(
                  'Sorry, we couldnt find an account with this "${widget.email}". Please contact to BTeC Security for more infomation.',),
            ),
        ),
      ),
    );
  }
}
