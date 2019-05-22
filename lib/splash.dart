import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.splashBackground,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: 250,
                        child: Image.asset('assets/icons/app_logo.png'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "UiTM",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: CustomFonts.appBar,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
