import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: CustomColors.front,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Login',style: CustomFonts.invTextStyle,),
    );
  }
}